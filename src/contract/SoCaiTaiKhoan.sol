// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0

pragma solidity ^0.8.20;

contract SoCaiTaiKhoan {
    struct GiaoDich {
        uint day;
        uint month;
        uint year;
        string moTa;

        uint realTime;

        uint no;
        uint co;

        string ghiChu;
        address nguoiTao;
    }

    address public quanLy;

    address[] keToan;

    uint[] giaoDichID;
    mapping(uint256 => GiaoDich) dSGD;

    constructor() {
        quanLy = msg.sender;
    }

    modifier chiQuanLy() {
        require(msg.sender == quanLy, "Phai la quan ly");
        _;
    }

    modifier chiKeToan() {
        bool check = false;
        for (uint i = 0; i < keToan.length; i++) {
            if (msg.sender == keToan[i]) check = true;
        }
        require(check == true, "Phai la ke toan");
        _;
    }

    function themKeToan(address newKeToan) external chiQuanLy{
        keToan.push(newKeToan);
    }

    function themGiaoDich(uint day,uint month,uint year,string memory moTa,uint no,uint co,string memory ghiChu,uint id) 
                        external chiKeToan {
        GiaoDich storage newGD = dSGD[id];
        newGD.day = day;
        newGD.month = month;
        newGD.year = year;
        newGD.moTa = moTa;
        newGD.no = no;
        newGD.co = co;
        newGD.ghiChu = ghiChu;
        newGD.nguoiTao = msg.sender;
        newGD.realTime = block.timestamp;

        giaoDichID.push(id);
    }

    function layGiaoDich(uint id) external view returns (uint,uint ,uint ,uint ,string memory,uint,uint,string memory, address) {
        GiaoDich storage s = dSGD[id];
        return (s.realTime,s.day, s.month, s.year, s.moTa, s.no, s.co, s.ghiChu, s.nguoiTao);
    }
                        
}