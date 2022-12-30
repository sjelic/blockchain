// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.25 <0.9.0;

library Types {
    enum UserType {
        Supplier, //0 
        PortAuthority, 
        Ship, 
        Distributer,
        Admin
    }

    struct SpecificUser {
        UserType uType;
        address userId;
        string name;
        string email;
        string country;
    }

    struct UserHistory {
        address userId;
        uint256 date;
    }



    enum MaterialType {
        AluminaHydrat, //0
        Wheat,
        SteelCoils,
        FertilizerInBags,
        Urea,
        NPK, 
        TSP, //triple super phosphat
        CementClinker,
        SteelHotRolledCoils,
        Barley,
        Lentils

    }

    struct MaterialHistory {
        UserHistory supplier;
        UserHistory[] port;
        UserHistory[] ship; 
        UserHistory[] dist;
    }

    struct Material {
        string id;
        string name; 
        string supplierName;
        address supplier;
        MaterialType mType;
        uint256 qty;
        string unit;
    }

    enum ShipPortStatus {
        arrival, //0
        arrivalAnchored,
        berthed,
        anchored,
        departure,
        bunkering,
        uwCleaning    
    }

    struct ShipPortHistory {
        ShipPort[] portHistory;
    }

    struct ShipPort {
        address portId;
        uint256 date;
        ShipPortStatus status;
        

    }

        function resolveMaterialType(Types.MaterialType mt) public pure returns (string memory) {
        if (mt == Types.MaterialType.AluminaHydrat)    
            return "Alumina Hydrat";
        if (mt == Types.MaterialType.Wheat)    
            return "Wheat";
        if (mt == Types.MaterialType.SteelCoils)    
            return "Steel Coils";
        if (mt == Types.MaterialType.FertilizerInBags)    
            return "Fertilizer in Bags";
        if (mt == Types.MaterialType.Urea)    
            return "Urea";
        if (mt == Types.MaterialType.NPK)    
            return "NPK";
        if (mt == Types.MaterialType.TSP)    
            return "TSP";
        if (mt == Types.MaterialType.CementClinker)    
            return "Cement Clinker";
        if (mt == Types.MaterialType.SteelHotRolledCoils)    
            return "Steel Hot Rolled Coils";
        if (mt == Types.MaterialType.Barley)    
            return "Barley";
        if (mt == Types.MaterialType.Lentils)
            return "Lentils";
        return "Unknown";
    }

    function resolveShipPortStatus(Types.ShipPortStatus sp) public pure returns (string memory) {
        if (sp == Types.ShipPortStatus.arrival)    
            return "Arrival";
        if (sp == Types.ShipPortStatus.arrivalAnchored)    
            return "Arrival/Anchored";
        if (sp == Types.ShipPortStatus.berthed)    
            return "Berthed";
        if (sp == Types.ShipPortStatus.anchored)    
            return "Anchored";
        if (sp == Types.ShipPortStatus.departure)    
            return "Departure";
        if (sp == Types.ShipPortStatus.bunkering)    
            return "Bunkering";
        if (sp == Types.ShipPortStatus.uwCleaning)    
            return "Uw cleaning";
        return "Unknown";
    }
}
