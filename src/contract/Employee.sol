// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0
pragma solidity ^0.8.20;

contract EmployeeData {

    string private  name;
    string private position;
    string internal id;
    uint internal salaryPerHour;
    address internal director; 
 
    struct DateInfor {
        uint day;
        uint month;
        uint year;
        uint beginHour;
        uint endHour;
    }

    DateInfor[] private listDate;

    constructor (string memory _name, string memory _position, string memory _id, uint _salaryPerHour)  {
        name = _name;
        position = _position;
        id = _id;
        salaryPerHour = _salaryPerHour;
        director = msg.sender;
    }

    function getName() public view returns (string memory){
        return name;
    }

    function getID() public view returns  (string memory) {
        return id;
    }

    function addDate(uint day, uint month, uint year, uint startHour, uint endHour) external isAValidDate(day, month, year) isDirector() {
        DateInfor memory newDate = DateInfor(day,month,year,startHour,endHour);
        listDate.push(newDate);
    }

    function getTotal() external view returns (uint) {
        uint totalHour = 0;
        for (uint i = 0; i < listDate.length; i++) {
            totalHour += (listDate[i].endHour - listDate[i].beginHour);
        }

        return totalHour * salaryPerHour;
    }

    function getHourAtDate(uint day, uint month, uint year) public isAValidDate(day,month,year) view returns (uint)  {
        return listDate[day].endHour - listDate[day].beginHour;
    }

    function isLeapYear(uint year) internal pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }

    modifier isAValidDate(uint day, uint month, uint year) {
        require(year >= 1 && month >= 1 && month <= 12 && day >= 1, "Invalid date");

        if (month == 2) {
            bool isLeap = isLeapYear(year);
            require(day <= 29 && (isLeap || day <= 28), "Invalid date");
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            require(day <= 30, "Invalid date");
        } else {
            require(day <= 31, "Invalid date");
        }
        _;
    }
    modifier isDirector() {
        require(msg.sender == director, "Only Director");
        _;
    }
}