// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract onlySelfDestructor {
    uint256 totalMinted;
    uint256 totalBurned;

    function activeAddressAmount() external view returns (uint256) {
        return totalMinted - totalBurned;
    }

    function _create(uint256 value) internal {
        uint256 offset = totalMinted;
         assembly {
            mstore(0, 0x6133ff6000526002601ef3000000000000000000000000000000000000000000)

            for {let i := div(value, 32)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 30, add(offset, 0))) pop(create2(0, 0, 30, add(offset, 1)))
                pop(create2(0, 0, 30, add(offset, 2))) pop(create2(0, 0, 30, add(offset, 3)))
                pop(create2(0, 0, 30, add(offset, 4))) pop(create2(0, 0, 30, add(offset, 5)))
                pop(create2(0, 0, 30, add(offset, 6))) pop(create2(0, 0, 30, add(offset, 7)))
                pop(create2(0, 0, 30, add(offset, 8))) pop(create2(0, 0, 30, add(offset, 9)))
                pop(create2(0, 0, 30, add(offset, 10))) pop(create2(0, 0, 30, add(offset, 11)))
                pop(create2(0, 0, 30, add(offset, 12))) pop(create2(0, 0, 30, add(offset, 13)))
                pop(create2(0, 0, 30, add(offset, 14))) pop(create2(0, 0, 30, add(offset, 15)))
                pop(create2(0, 0, 30, add(offset, 16))) pop(create2(0, 0, 30, add(offset, 17)))
                pop(create2(0, 0, 30, add(offset, 18))) pop(create2(0, 0, 30, add(offset, 19)))
                pop(create2(0, 0, 30, add(offset, 20))) pop(create2(0, 0, 30, add(offset, 21)))
                pop(create2(0, 0, 30, add(offset, 22))) pop(create2(0, 0, 30, add(offset, 23)))
                pop(create2(0, 0, 30, add(offset, 24))) pop(create2(0, 0, 30, add(offset, 25)))
                pop(create2(0, 0, 30, add(offset, 26))) pop(create2(0, 0, 30, add(offset, 27)))
                pop(create2(0, 0, 30, add(offset, 28))) pop(create2(0, 0, 30, add(offset, 29)))
                pop(create2(0, 0, 30, add(offset, 30))) pop(create2(0, 0, 30, add(offset, 31)))
                offset := add(offset, 32)
            }

            for {let i := and(value, 0x1F)} i {i := sub(i, 1)} {
                pop(create2(0, 0, 30, offset))
                offset := add(offset, 1)
            }
        } 
        totalMinted = offset;
    }

    function computeAddress(uint256 salt) public view returns (address child) {
        assembly {
            let data := mload(0x40)
            mstore(data,
                add(
                    0xff00000000000000000000000000000000000000000000000000000000000000,
                    shl(0x58, address())
                )
            )
            mstore(add(data, 21), salt)
            mstore(add(data, 53), 0x6133ff6000526002601ef3000000000000000000000000000000000000000000)
            mstore(add(data, 53), keccak256(add(data, 53), 30))
            child := and(keccak256(data, 85), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
        }
    }

    function destroyAddress(address[] calldata _address) external {
        uint length = _address.length;

        for (uint i = 0; i < length; i++) {
            _address[i].call("");
        }
        totalBurned = totalBurned + length;
    }

    function create2Address(uint256 amount) external {
        _create(amount);
    }
}