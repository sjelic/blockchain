// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";

contract Users {

    address internal admin; 

    mapping(address => Types.SpecificUser) internal allUsers;
    mapping(address => Types.ShipPortHistory) internal shipPortHistory;

    event UserCreated(string name, string email, Types.UserType userType);
    event UserRemoved(string name, string email, Types.UserType userType);

    event ShipStatusChanged(string shipName, address shipAddress, string portName, address portAddress, Types.ShipPortStatus status );

    function hasAccountType(Types.UserType uType, address account) internal view returns (bool) {
        require(account != address(0));
        return (allUsers[account].userId != address(0) && allUsers[account].uType == uType);
    }

    function addressRegistered(address account) internal view returns (bool) {
        require(account != address(0));
        return allUsers[account].userId != address(0) || account == admin;
    }

    function getUser(address account) internal view returns (Types.SpecificUser memory)
    {
        require(account != address(0));
        return allUsers[account];
    }


    function addUser(Types.SpecificUser memory user) internal {
        require(user.userId != address(0));
        require(msg.sender == admin, "Only admin may add new users.");
        require(!addressRegistered(user.userId), "User with that address already exists.");
        allUsers[user.userId] = user;
        emit UserCreated(user.name, user.email, user.uType);
        
    }

    function removeUser(address account) internal {
        require(account != address(0));
        require(msg.sender == admin, "Only admin may remove existing users.");
        require(addressRegistered(account), "User with specified account address does not exist.");
        string memory name = allUsers[account].name;
        string memory email = allUsers[account].email;
        Types.UserType uType = allUsers[account].uType;
        delete allUsers[account];
        emit UserRemoved(name, email, uType);
    }



    function changeShipStatus(address portId_, uint256 status_, uint256 currentTime) internal portExists(portId_) shipExists(msg.sender) {
        Types.ShipPort memory sp = Types.ShipPort({
            portId: portId_,
            date: currentTime,
            status: Types.ShipPortStatus(status_)
        });

        shipPortHistory[msg.sender].portHistory.push(sp);
        string memory shipName = allUsers[msg.sender].name;
        string memory portName = allUsers[portId_].name;

        emit ShipStatusChanged(shipName, msg.sender, portName, portId_, Types.ShipPortStatus(status_));
    }

    function getSpecificShip(address shipId) internal view returns (Types.SpecificUser memory, Types.ShipPortHistory memory)
    {

        return (allUsers[shipId], shipPortHistory[shipId]);
    }

    modifier portExists(address id) {
        require(allUsers[id].userId != address(0) && allUsers[id].uType == Types.UserType.PortAuthority);
        _;
    }
    modifier shipExists(address id) {
        require(allUsers[id].userId != address(0) && allUsers[id].uType == Types.UserType.Ship, "Only a ship may change its status.");
        _;
    }


}
