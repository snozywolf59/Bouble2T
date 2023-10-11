// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0
pragma solidity ^0.8.20;

contract HDSXKD {
    struct KetQua {
        uint month;
        uint year;
        uint[2] doanhThuBanHangVaCCDV;
        uint[2] loiNhuanGopVeBanHangVaCCDV;
    }

    address public quanLy;

    address[] keToan;

    uint[] giaoDichID;
    mapping(uint256 => KetQua) dSGD;

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

}