import ballerina/http;
import ballerina/io;

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

http:Client http_client = check new ("localhost:9090/logistic");

public function main() returns error? {
    io:println("Shipment type:");
    io:println("1. Standard Delivery");
    io:println("2. Express Delivery");
    io:println("3. International Delivery");
    string choice = io:readln("Enter Shipment type Choice: ");
    Shipment request = {
        firstName: "",
        lastName: "",
        contactNumber: "",
        shipmentType: "",
        pickupLocation: "",
        deliveryLocation: "",
        preferredTimeSlot: ""
    };
    if choice == "1" {
        string shipment = shipment_type("standard-delivery");
        request = {
            firstName: io:readln("Enter your first name: "),
            lastName: io:readln("Enter your last name: "),
            contactNumber: io:readln("Enter your contact number: "),
            shipmentType: shipment,
            pickupLocation : io:readln("Enter pickup location: "),
            deliveryLocation : io:readln("Enter delivery location: "),
            preferredTimeSlot : io:readln("Enter preferred time slot: ")
        };
    }
    else if choice == "2" {
        string shipment = shipment_type("express-delivery");
        request = {
            firstName: io:readln("Enter your first name: "),
            lastName: io:readln("Enter your last name: "),
            contactNumber: io:readln("Enter your contact number: "),
            shipmentType: shipment,
            pickupLocation: io:readln("Enter pickup location: "),
            deliveryLocation: io:readln("Enter Delivery location: "),
            preferredTimeSlot: io:readln("Enter preferred time slot: ")
        };
    }
    else if choice == "3" {
        string shipment = shipment_type("international-delivery");
        request = {
            firstName: io:readln("Enter your first name: "),
            lastName: io:readln("Enter your last name: "),
            contactNumber: io:readln("Enter your contact number: "),
            shipmentType: shipment,
            pickupLocation: io:readln("Enter pickup location: "),
            deliveryLocation: io:readln("Enter Delivery"),
            preferredTimeSlot: io:readln("Enter preferred time slot: ")
        };
    }

    string response = check http_client->/sending.post(request);

    io:println(response);

}

function shipment_type(string shipment_type) returns string {
    if (shipment_type == "standard-delivery") {
        return shipment_type;
    }
    else if (shipment_type == "express-delivery") {
        return shipment_type;
    }
    else if (shipment_type == "international-delivery") {
        return shipment_type;
    }
    else {
        return "Invalid shipment type";
    }
}
