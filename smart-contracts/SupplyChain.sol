// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.25 <0.9.0;

import "./Users.sol";
import "./Cargo.sol";


contract SupplyChain is Cargo, Users {

    constructor(string memory name_, string memory email_) {
        Types.SpecificUser memory admin_ = Types.SpecificUser({
            uType: Types.UserType.Admin,
            userId: msg.sender,
            name: name_,
            email: email_,
            country: ""
        });
        allUsers[admin_.userId] = admin_;
        admin = msg.sender;
    }

    function getAllCargo() public view returns (Types.Material[] memory) {
        return materials;
    }

    function getMyCargo() public view returns (Types.Material[] memory) {
        return getUserMaterials();
    }

    function getSingleCargo(string memory id) public view returns (Types.Material memory, Types.MaterialHistory memory) {
        return getSpecificMaterial(id);
    }

    function addCargo(string memory cargoId, string memory cargoName, string memory cargoSupplierName, address cargoSupplier,
                    Types.MaterialType cargoMType, uint256 cargoQty, string memory cargoUnit, uint256 currentTime) public onlySupplier{
        Types.Material memory cargo = Types.Material({
            id: cargoId,
            name: cargoName,
            supplierName: cargoSupplierName,
            supplier: cargoSupplier,
            mType: cargoMType,
            qty: cargoQty,
            unit: cargoUnit
        });
        addNewMaterial(cargo, currentTime);
    }

    function trasferCargo(address targetUser, string memory cargoId, uint256 currentTime) public {
        require(isUserExists(targetUser), "User not found.");

        transferMaterial(targetUser, cargoId, allUsers[targetUser], currentTime);
    }

    function addNewUser(Types.UserType uType_, address userId_, string memory name_, string memory email_, string memory country_) public {
        Types.SpecificUser memory user = Types.SpecificUser({
            uType: uType_,
            userId: userId_,
            name: name_,
            email: email_,
            country: country_
        });
        addUser(user);
    }

    function getUserDetails (address id) public view returns (Types.SpecificUser memory) {
        return getUser(id);
    }

    function getMyDetails() public view returns (Types.SpecificUser memory) {
        return getUserDetails(msg.sender);
    } 

    function changeShipPortStatus(address portId, uint256 status, uint256 currentTime) public{
        changeShipStatus(portId, status, currentTime);
    }

    function getShipDetails(address id) public view returns (Types.SpecificUser memory, Types.ShipPortHistory memory)
    {
        return getSpecificShip(id);
    }


    function getSingleCargoHumanReadable(string memory id) public view returns (string memory MaterialType, string memory MaterialName,
                                                        string memory SenderName,string[] memory portName, uint256[] memory portTime,
                                                        string[] memory shipName, uint256[] memory shipTime) {
        Types.Material memory mat;
        Types.MaterialHistory memory mHistory;
        (mat, mHistory) = getSpecificMaterial(id);

        MaterialType = Types.resolveMaterialType(mat.mType);
        MaterialName = mat.name;
        SenderName = mat.supplierName;

        portName = new string[](mHistory.port.length);
        portTime = new uint256[](mHistory.port.length);
        for(uint256 i=0; i< mHistory.port.length; i++) {
            portName[i] = getUserDetails(mHistory.port[i].userId).name;
            portTime[i] = mHistory.port[i].date;
        }

        shipName = new string[](mHistory.ship.length);
        shipTime = new uint256[](mHistory.ship.length);
        for(uint256 i=0; i< mHistory.ship.length; i++) {
            shipName[i] = getUserDetails(mHistory.ship[i].userId).name;
            shipTime[i] = mHistory.ship[i].date;
        }

        return (MaterialType, MaterialName, SenderName, portName, portTime, shipName, shipTime);

    }

    function geyMyShipDetailsHumanReadable() public view returns (string memory, string[] memory, uint256[] memory,string[] memory) {
    
        return getShipDetailsHumanReadable(msg.sender);
    }

    function getShipDetailsHumanReadable(address id) public view returns (string memory ShipName, string[] memory portName, uint256[] memory portTime,string[] memory portStatus) {
        Types.SpecificUser memory ship;
        Types.ShipPortHistory memory sHistory;
        (ship, sHistory) = getSpecificShip(id);

        ShipName = ship.name;
        

        portName = new string[](sHistory.portHistory.length);
        portTime = new uint256[](sHistory.portHistory.length);
        portStatus = new string[](sHistory.portHistory.length);
        for(uint256 i=0; i< sHistory.portHistory.length; i++) {
            portName[i] = getUserDetails(sHistory.portHistory[i].portId).name;
            portTime[i] = sHistory.portHistory[i].date;
            portStatus[i] = Types.resolveShipPortStatus(sHistory.portHistory[i].status);
        }

        return (ShipName, portName, portTime, portStatus);

    }




    function isUserExists(address account) internal view returns (bool) {
        if (account == address(0)) 
            return false;
        if (allUsers[account].userId != address(0))
            return true;
        else
            return false;
    }

    modifier onlySupplier() {
        require(msg.sender != address(0), "Sender's address is Empty");
        require(allUsers[msg.sender].userId != address(0), "User's address is Empty");
        require(
            Types.UserType(allUsers[msg.sender].uType) ==
                Types.UserType.Supplier,
            "Only supplier can add"
        );
        _;
    }
}
