// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";

contract Cargo {
    Types.Material[] internal materials;
    mapping(string => Types.Material) internal material; 
    mapping(address => string[]) internal userLinkedMaterials;
    mapping(string => Types.MaterialHistory) internal materialHistory;

    event NewMaterial(string id, string name, string supplierName, Types.MaterialType mType, uint256 qty, string unit);

    function addNewMaterial(Types.Material memory mat, uint256 currentTime) internal materialNotExists(mat.id) {
        require(mat.supplier == msg.sender, "Only supplier may add new material.");
        materials.push(mat);
        material[mat.id] = mat;
        materialHistory[mat.id].supplier = Types.UserHistory({
            userId: msg.sender,
            date: currentTime
        });
        userLinkedMaterials[msg.sender].push(mat.id);
        emit NewMaterial(mat.id, mat.name, mat.supplierName, mat.mType, mat.qty, mat.unit);
    }

    event MaterialTransfer(string id, string name, string supplierName, Types.MaterialType, uint256 qty, string unit, string newOwnName, string newOwnMail);


    function transferMaterial(address user_id, string memory materialId, Types.SpecificUser memory userDetails,
                                uint256 currentTime) internal materialExists(materialId) {
        require(userDetails.userId == user_id, "provided details must be for user_id user.");
        require(hasUserMaterial(materialId), "Only the one who has cargo may transfer it.");

        Types.Material memory mat = material[materialId];

        Types.UserHistory memory uh = Types.UserHistory({
            userId: user_id,
            date: currentTime
        });

        if(Types.UserType(userDetails.uType) == Types.UserType.PortAuthority) {
            materialHistory[materialId].port.push(uh);
        }
        else if(Types.UserType(userDetails.uType) == Types.UserType.Ship){
            materialHistory[materialId].ship.push(uh);
        }
        else if(Types.UserType(userDetails.uType) == Types.UserType.Distributer){
            materialHistory[materialId].dist.push(uh);
        } 
        else {
            revert("Not valid operation.");
        }

        transferOwnership(msg.sender, user_id, materialId);

        emit MaterialTransfer(mat.id, mat.name, mat.supplierName, mat.mType, mat.qty, mat.unit, userDetails.name, userDetails.email);
    }

    function transferOwnership(address oldOwnId, address newOwnId, string memory materialId) internal {
        userLinkedMaterials[newOwnId].push(materialId);
        string[] memory oldOwnMaterials = userLinkedMaterials[oldOwnId];
        uint256 matchIndex = (oldOwnMaterials.length + 1);
        for (uint256 i = 0; i < oldOwnMaterials.length; i++) {
            if (compareStrings(oldOwnMaterials[i], materialId)) {
                matchIndex = i;
                break;
            }
        }
        assert(matchIndex < oldOwnMaterials.length); // Match found
        if (oldOwnMaterials.length == 1) {
            delete userLinkedMaterials[oldOwnId];
        } else {
            userLinkedMaterials[oldOwnId][matchIndex] = userLinkedMaterials[oldOwnId][oldOwnMaterials.length - 1];
            delete userLinkedMaterials[oldOwnId][oldOwnMaterials.length - 1];
            userLinkedMaterials[oldOwnId].pop();
        }
    }


    function getUserMaterials() internal view returns (Types.Material[] memory) {
        string[] memory ids_ = userLinkedMaterials[msg.sender];
        Types.Material[] memory mats = new Types.Material[](ids_.length);
        for (uint256 i = 0; i < ids_.length; i++) {
            mats[i] = material[ids_[i]];
        }
        return mats;
    }

    function hasUserMaterial(string memory matId) internal view returns (bool) {
        string[] memory ids_ = userLinkedMaterials[msg.sender];
        for (uint256 i = 0; i < ids_.length; i++) {
            if (compareStrings(ids_[i], matId))
                return true;
        }
        return false;
    }

    function getSpecificMaterial(string memory matId) internal view returns (Types.Material memory, Types.MaterialHistory memory)
    {
        return (material[matId], materialHistory[matId]);
    }


    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    modifier materialExists(string memory id) {
        require(!compareStrings(material[id].id, ""));
        _;
    }

    modifier materialNotExists(string memory id) {
        require(compareStrings(material[id].id, ""));
        _;
    }

}
