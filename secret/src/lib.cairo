fn main() {
    let hash_result: felt252 = 0x23c16a2a9adbcd4988f04bbc6bc6d90275cfc5a03fbe28a6a9a3070429acb96;
    let mut n = 1;
    let MAX_RANGE: felt252 = 5000;
    let mut guess = core::pedersen::pedersen(1000, n);
    while guess != hash_result {
        n += 1;
        guess = core::pedersen::pedersen(1000, n);
        if n == MAX_RANGE + 1 {
            break;
        }
    };
    if n != MAX_RANGE + 1 {
        println!("Guessed number: {}", n);
    } else {
        println!("Number not guessed between the range");
    }
}
