contract;

dep message;

use std::{call_frames::contract_id, logging::log};

use merkle::StorageMerkleTree;
use message::Message;

// TODO move the abi declaration to its own library?
abi Mailbox {
    #[storage(read, write)]
    fn dispatch(destination_domain: u32, recipient: b256, message_body: Vec<u8>) -> b256;

    #[storage(read)]
    fn count() -> u64;

    #[storage(read)]
    fn root() -> b256;
}

storage {
    merkle_tree: StorageMerkleTree = StorageMerkleTree {},
}

impl Mailbox for Contract {
    #[storage(read, write)]
    fn dispatch(
        destination_domain: u32,
        recipient: b256,
        message_body: Vec<u8>,
    ) -> b256 {
        let message = Message {
            version: 1u8,
            nonce: 2u32,
            origin_domain: 3u32,
            sender: contract_id().into(),
            destination_domain,
            recipient,
            body: message_body,
        };

        storage.merkle_tree.insert(0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb);

        log(message);

        std::constants::ZERO_B256
    }

    #[storage(read)]
    fn count() -> u64 {
        storage.merkle_tree.get_count()
    }

    #[storage(read)]
    fn root() -> b256 {
        storage.merkle_tree.root()
    }
}
