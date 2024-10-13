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
