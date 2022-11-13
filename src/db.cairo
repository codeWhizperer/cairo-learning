%lang starknet


from starkware.cairo.common.cairo_builtins import HashBuiltin



// Build a program that stores students’ records (name, age, gender).

// **Project requirement:**

// - Your contract should have a storage variable **admin_address** that stores an admin address. === done;
// - Your contract should have a storage variable **student_details** that maps the student’s address to their details.  === done
// - It should have a **constructor** that takes in an *address* argument and initialises it as the *admin*.  ==== done
// - It should have an external function **store_details** that takes in *name*, *age*, and *gender* as arguments to be stored in the *student_details* storage variable. ===**
// - It should have a view function **get_name** that takes in a student’s address and returns the student’s name.

// **Hint**:

// You can use a struct for student details.

struct Students{
    name:felt,
    age:felt,
    gender:felt,
}

@storage_var
func admin_address() -> (res:felt){
}

@storage_var
func student_details(student_address : felt) -> (student : Students){
}

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner_address:felt
) {
   admin_address.write(value=owner_address);
   return (); 
}

@external
func store_details{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(_name : felt,  _age : felt, student_address : felt, _gender : felt) -> (){
    let _student_details = Students(_name, _age, _gender);
    student_details.write(student_address, _student_details);
    return();
}

@view
func get_name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    address : felt
) -> (name: Students) {
    let (name) = student_details.read(address);
    return (name=name);
}