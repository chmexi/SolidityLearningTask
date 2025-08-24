// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContract {
    address public _owner;
    uint256 public _expiredTime;

    mapping(address donator => uint256 amount) public _donations;

    struct Donator {
        address addr;
        uint256 amount;
    }
    Donator[3] public _top3Donators;

    event Donation(address donator_, uint256 amount_);

    constructor() {
        _owner = msg.sender;
        _expiredTime = block.timestamp + 60 * 3; // 三分钟内可以捐赠
    }

    modifier onlyOwner {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    modifier onlyBeforeExpiredTime {
        require(block.timestamp < _expiredTime, "It's already after the expired time");
        _;
    }

    function donate() public payable onlyBeforeExpiredTime {
        _donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
        uint256 curDonation = _donations[msg.sender];
        if (_top3Donators[0].amount < curDonation) {
            _top3Donators[2] = _top3Donators[1];
            _top3Donators[1] = _top3Donators[0];
            _top3Donators[0] = Donator(msg.sender, curDonation);
        }
        else if (_top3Donators[1].amount < curDonation) {
            _top3Donators[2] = _top3Donators[1];
            _top3Donators[1] = Donator(msg.sender, curDonation);
        }
        else if (_top3Donators[2].amount < curDonation) {
            _top3Donators[2] = Donator(msg.sender, curDonation);
        }
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(_owner).call{value: address(this).balance}("");
        require(success, "Transfer failed!");
    }

    function getDonation() public view returns(uint256) {
        return _donations[msg.sender];
    }

    function getDonationOf(address addr) public view returns(uint256) {
        return _donations[addr];
    }

    function getTop3Donators() public view returns(Donator[3] memory) {
        return _top3Donators;
    }
}