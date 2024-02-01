# Initialization Of the Motors Script
import thorlabs_apt as apt
serial_numbers = [83811904, 83811667, 83811901, 83811664]

Bob_QWP_RL_Settings = {
    # Settings are in the form H, V, D, A, R, L for all wave plates
    "H": 3, "V": 3, "D": 3, "A": 3,"R": 138, "L": 48,
    "B": 3, "P": 3, "Z": 3, "S": 3}
    
# A dictionary of dictionaries of all the settings for the half wave plates.
WavePlateSettings = { 83811904 : # This is Alice's QWP
    # Settings are in the form H, V, D, A, R, L for all wave plates
    {"H": -0.7, "V": -0.7, "D": -0.7, "A": -0.7, "R": 135.3, "L": 45.3, 
    "B": -0.7, "P": -0.7, "Z": -0.7, "S": -0.7}#An internal dictionary.
    
    , 83811901 : # This is Bob's HWP
    # Settings are in the form H, V, D, A, R, L for all wave plates
    {"H": -5.15, "V": 39.85, "D": 62.35, "A": 17.35, "R": -5.15, "L": -5.15,
    "P": 51.1, "B": 6.1, "Z": 28.6, "S": 73.6}
    
    , 83811667 : # This is Alice's HWP
    # Settings are in the form H, V, D, A, R, L for all wave plates
    {"H": -1, "V": 44, "D": 66.5, "A": 21.5, "R": -1, "L": -1,
    "P": 55.25, "B": 10.25, "Z": 32.75, "S": 77.75}#An internal dictionary.
    
    , 83811664 : # This channel is not hooked up to anything yet.
    {"H": 0, "V": 0, "D": 0, "A": 0, "R": 0, "L": 0, "B": 0,
    "P": 0, "Z": 0, "S": 0}
    # So its values are all set to zero.
    }

class aptWrapper():
    """This class allows you to control the motor based upon its serial number.
    It also overloads the move_to command to take in strings as inputs so that
    it is easier to read when the command issued is printed.
    """
    def __init__(self, serial_num, Identifier): # Parameterized Constructor.
        if serial_num not in serial_numbers:
            raise ValueError("Serial Number not found")
        else:
            self.serial_num = serial_num
            
            # Initialize the appropriate equipment.
            self.motor = apt.Motor(serial_num)
            
            self.settings = WavePlateSettings[serial_num]
            
            self.name = Identifier
            
            self.state = "X"
            # Set the initial state to be X. 
            # This will be changed every move_to call
            
    
    def __repr__(self):
        # The representation of an object of aptWrapper when it is printed.
        return self.name
        
    def move_to(self, stringState):
        if stringState in self.settings.keys():
            if self.state != stringState:
                print("Valid State: " + stringState)
                print("Moving " + self.name + " to setting: " + stringState)
                print("Command Issued: " + "self.motor.move_to(" + str(self.settings[stringState]) + ",True)")
                self.motor.move_to(self.settings[stringState], True)
                self.state = stringState
                return
            else:
                print(self.name + "is already at state: " + stringState)
                print("Moving to next controller now.")
                return
        else:
            # Throwing the error should stop all code at this point;
            # so no need to check what is returned.
            raise ValueError("Inappropriate string state was input."+ 
            "The valid options are H,V,D,A,R,L,S,B,Z,P")
    def move_quick(self, stringState):
        if stringState in self.settings.keys():
            if self.state != stringState:
                print("Valid State: " + stringState)
                print("Moving " + self.name + " to setting: " + stringState)
                print("Command Issued: " + "self.motor.move_to(" + str(self.settings[stringState]) + ")")
                self.motor.move_to(self.settings[stringState])
                self.state = stringState
                return
            else:
                print(self.name + "is already at state: " + stringState)
                print("Moving to next controller now.")
                return
        else:
            # Throwing the error should stop all code at this point;
            # so no need to check what is returned.
            raise ValueError("Inappropriate string state was input."+ 
            "The valid options are H,V,D,A,R,L,S,B,Z,P")

            
Alice_HWP = aptWrapper(83811667, "Alice HWP")
Alice_QWP = aptWrapper(83811904, "Alice QWP")
Bob_HWP = aptWrapper(83811901, "Bob HWP")