import ballerinax/kafka;
import ballerina/sql;
import ballerinax/mysql;
import ballerina/http;
import ballerina/io;
import ballerina/random;

type Customer record {
    int id;
    string firstName;
    string lastName;
    string contactNumber;
};

type Shipment record {
    string deliveryLocation;
    string contactNumber;
    string trackingNumber = "";
    string shipmentType;
    string pickupLocation;
    string preferredTimeSlot;
    string firstName;
    string lastName;
};

service /logistic on new http:Listener(9090) {
    private final mysql:Client db;
    private final kafka:Producer kafkaProducer;

    function init() returns error? {
        self.kafkaProducer = check new(kafka:DEFAULT_URL);
        self.db = check new("localhost", "root", "password", "logistics_db", 3306);
    }

    resource function post sending(Shipment received) returns string | error? {
        sql:ParameterizedQuery insert_customer = INSERT INTO Customers (first_name, last_name, contact_number) VALUES (${received.firstName}, ${received.lastName}, ${received.contactNumber});
        sql:ExecutionResult _ = check self.db->execute(insert_customer);

        int tracking_number = check random:createIntInRange(1000000000, 9999999999);
        sql:ParameterizedQuery insert_shipment = INSERT INTO Shipments (shipment_type, pickup_location, delivery_location, preferred_time_slot, tracking_number) VALUES (${received.shipmentType}, ${received.pickupLocation}, ${received.deliveryLocation}, ${received.preferredTimeSlot}, ${tracking_number});
        sql:ExecutionResult _ = check self.db->execute(insert_shipment);

        check self.kafkaProducer->send({topic: received.shipmentType, value: received});

        io:println("Shipment confirmed");
        return string packageId: ${tracking_number};
    }
}
