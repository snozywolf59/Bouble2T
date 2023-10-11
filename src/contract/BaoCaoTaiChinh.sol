// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0
pragma solidity ^0.8.20;

struct TaiSanNganHan {
    uint256[2] TienMatVaTuongDuong;
    uint256[2] DauTuTaiChinh;
    uint256[2] PhaiThuNganHan;
    uint256[2] HangTonKhoDauNam;
    uint256[2] TaiSanNganHangKhac;
}

struct TaiSanDaiHan {
    uint256[2] PhaiThuDaiHan;
    uint256[2] TaiSanCoDinh;
    uint256[2] BatDongSanDauTu;
    uint256[2] TaiSanDoDangDaiHan;
    uint256[2] TaiSanDaiHanKhac;
}

struct VongVon {
    uint256[2] NoNganHan;
    uint256[2] PhaiTraNganHan;
    uint256[2] NoDaiHan;
    uint256[2] VongVonChuSoHuu;
}

struct BaoCaoTaiChinh {
    TaiSanNganHan taiSanNganHan;
    TaiSanDaiHan taiSanDaiHan;
    VongVon  vongVon;  
    uint id;
    uint year;// = (block.timestamp / 31557600) + 1970;
    uint month; //= (block.timestamp / 2629800) % 12 + 1;
    uint8 notNull;
}

contract DanhSachBaoCaoTaiChinh {
    address internal  quanLy;

    address[] keToan;

    uint[] BCTCID;
    mapping(uint256 => BaoCaoTaiChinh) danhSachBCTC;

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

    function themBaoCao(TaiSanNganHan memory _taiSanNganHan,
                        TaiSanDaiHan memory _taiSanDaiHan,
                            VongVon memory _vongVon) external chiQuanLy() {
        uint year = (block.timestamp / 31557600) + 1970;
        uint month = (block.timestamp / 2629800) % 12 + 1;
        uint id = year * 12 + month;
        BaoCaoTaiChinh storage baoCaoMoi = danhSachBCTC[id];
        baoCaoMoi.notNull = 1;
        baoCaoMoi.taiSanDaiHan = _taiSanDaiHan;
        baoCaoMoi.taiSanNganHan = _taiSanNganHan;
        baoCaoMoi.vongVon = _vongVon;
    }

    function layBaoCao(uint year, uint month) external view chiKeToan chiQuanLy returns (uint, uint, uint, uint, uint, uint){
        uint id = year * 12 + month;
        BaoCaoTaiChinh storage temp = danhSachBCTC[id];
        uint nganHanDauNam = temp.taiSanNganHan.TienMatVaTuongDuong[0] + temp.taiSanNganHan.DauTuTaiChinh[0]
                            + temp.taiSanNganHan.PhaiThuNganHan[0] + temp.taiSanNganHan.HangTonKhoDauNam[0]
                            + temp.taiSanNganHan.TaiSanNganHangKhac[0];
        
        uint nganHanCuoiNam = temp.taiSanNganHan.TienMatVaTuongDuong[1] + temp.taiSanNganHan.DauTuTaiChinh[1]
                            + temp.taiSanNganHan.PhaiThuNganHan[1] + temp.taiSanNganHan.HangTonKhoDauNam[1]
                            + temp.taiSanNganHan.TaiSanNganHangKhac[1];

        /*
        uint256[2] PhaiThuDaiHan;
        uint256[2] TaiSanCoDinh;
        uint256[2] DauTuVaoTaiSanTaiChinh;
        uint256[2] DauTuVaoCongTyCon;
        uint256[2] TaiSanDaiHanKhac;
        */
        uint daiHanDauNam = temp.taiSanDaiHan.PhaiThuDaiHan[0] + temp.taiSanDaiHan.TaiSanCoDinh[0] + 
                                temp.taiSanDaiHan.BatDongSanDauTu[0] + temp.taiSanDaiHan.TaiSanDoDangDaiHan[0] + 
                                temp.taiSanDaiHan.TaiSanDaiHanKhac[0];

        uint daiHanCuoiNam = temp.taiSanDaiHan.PhaiThuDaiHan[1] + temp.taiSanDaiHan.TaiSanCoDinh[1] + 
                                temp.taiSanDaiHan.BatDongSanDauTu[1] + temp.taiSanDaiHan.TaiSanDoDangDaiHan[1] + 
                                temp.taiSanDaiHan.TaiSanDaiHanKhac[1];

            /*
                uint256[2] NoNganHan;
                uint256[2] PhaiTraNganHan;
                uint256[2] NoDaiHan;
                uint256[2] PhaiTraNganHan;
            */
        uint vongVonDauNam = temp.vongVon.NoNganHan[0] +  temp.vongVon.PhaiTraNganHan[0] + temp.vongVon.NoDaiHan[0] + 
                                temp.vongVon.PhaiTraNganHan[0];
        uint vongVonCuoiNam = temp.vongVon.NoNganHan[1] +  temp.vongVon.PhaiTraNganHan[1] + temp.vongVon.NoDaiHan[1] + 
                                temp.vongVon.PhaiTraNganHan[1];
        return (nganHanDauNam, nganHanCuoiNam,daiHanDauNam,daiHanCuoiNam,vongVonDauNam,vongVonCuoiNam);
    }
}