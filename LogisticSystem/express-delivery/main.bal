import ballerinax/kafka;
import ballerinax/mysql;
import ballerina/io;
import ballerinax/mysql.driver as _;

mysql:Client db = check new("localhost", "root", "password", "logistics_db",3306);

listener kafka:Listener expressConsumer = check new(kafka:DEFAULT_URL, {
    groupId: "express-delivery-group",  
    topics: "express-delivery"
});

kafka:Producer confirmationProducer = check new(kafka:DEFAULT_URL);

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

type Confirmation record {
    string confirmationId;
    string shipmentType;
    string pickupLocation;
    string deliveryLocation;
    string estimatedDeliveryTime;
    string status;
};


service on expressConsumer {
 remote function onConsumerRecord(Shipment[] request) returns error? {
        foreach Shipment shipment_details in request {
            Confirmation confirmation = {
                confirmationId: shipment_details.trackingNumber,
                shipmentType: shipment_details.shipmentType,
                pickupLocation: shipment_details.pickupLocation,
                deliveryLocation: shipment_details.deliveryLocation,
                estimatedDeliveryTime: "1 days",
                status: "Confirmed"
            };
            io:println(confirmation.confirmationId);
            check confirmationProducer->send({topic: "confirmationShipment", value: confirmation});

            io:println(shipment_details.firstName + " " + shipment_details.lastName + " " + shipment_details.contactNumber + " " + shipment_details.trackingNumber);
        }
    }
}
