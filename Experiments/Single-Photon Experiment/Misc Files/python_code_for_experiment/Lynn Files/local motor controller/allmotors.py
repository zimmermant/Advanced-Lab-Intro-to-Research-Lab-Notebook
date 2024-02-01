# -*- coding: utf-8 -*-
"""
Created on Tue Jun  5 12:26:35 2018

@author: Nick
"""
import initialize_the_motors
import time
states = "HhVvAaDdRrLlsSbBpPzZ" 
# The capital and lowercase versions of HVADRLSBPZ.


Bob_QWP_RL_Settings = {
            # Settings are in the form H, V, D, A, R, L, B, P, Z, Set
            # for all wave plates. S stands for smilely face 88.75 above axis
            # B stands for sailboat 56.25 above axis. P stands for sailboat perp
            # 11.25 above the axis. Z stands for smilely perp 33.75 degrees above axis.
            "H": 3, "V": 3, "D": 3, "A": 3,"R": 138, "L": 48,
            "B": 3, "P": 3, "Z": 3, "S": 3}
            # Currently Bob's QWP is not automated so this will need to be moved manually.
            
class AllMotors:
    
    def __init__(self, serial_numbers):
        # serial_numbers is a list of serial numbers used to control the motors
        # in the order Alice HWP, Alice QWP, and then Bob's HWP.
        if len(serial_numbers) < 3:
            raise ValueError("expected at least 3 motors to be controlled")
        # Initialize all the motors.
        self.AHWP = initialize_the_motors.aptWrapper(serial_numbers[0], "Alice HWP")
        self.AQWP = initialize_the_motors.aptWrapper(serial_numbers[1], "Alice QWP")
        self.BHWP = initialize_the_motors.aptWrapper(serial_numbers[2], "Bob HWP")
        self.Bob_QWP_pre_state = self.Move_Bob_QWP("H", 'firstTime')
        
        self.state = self.reset() # Move everything to measure HH.
        
    def __repr__(self):
        
        output = "This is a class used to control Alice's HWP, and QWP as well"
        output += " Bob's HWP and Bob's QWP (requires human input for BQWP)."
        output += "/n" + "Alice HWP: " + self.AHWP.position() + "/n"
        output += "Alice QWP: " + self.AQWP.position() + "/n"
        output += "Bob HWP: " + self.BHWP.position() + "/n"
        output += "Bob QWP should be at "+ self.Bob_QWP_RL_Settings[self.state]
        output += "/n" + "This corresponds to the state: " + self.state
        return output
    
    def Move_Bob_QWP(self, Bob_State, *keyword_parameters):
        if 'firstTime' in keyword_parameters:
            # Want it to ask you to move it to H.
            Bob_State = "H"
        else:
            BQWP_pre = self.Bob_QWP_pre_state
        Bob_QWPangle = Bob_QWP_RL_Settings[Bob_State]
        # Below will only run if Bob's new state requires a different QWP angle.
        print("Please move Bob's QWP to state: " + Bob_State)
        print("As a reminder: Bob's QWP should be at: " + str(Bob_QWPangle))
        ready_to_record = False
        while(ready_to_record  != True):
            userin=input("Is Bob's QWP set to "+ str(Bob_QWPangle) + "? y/n ")
            try:
                if str(userin) == "y":
                    # Set the loop condition to exit.
                    ready_to_record = True
                    self.Bob_QWP_pre_state = Bob_State
                    return Bob_State
                else:
                    print("Please move Bob's QWP to " + str(Bob_QWPangle) + ".")
                    print("Waiting 1 second for you to move it.")
                    time.sleep(1)
            except:
                print("Please try again. What you input was not valid.")
            
    def move_to(self, stringState):
        # This function assumes that there is a move_quick function in
        # the class aptWrapper
        if type(stringState) == str:
            # Confirm the input is the right type
            A_State = stringState[0] # Alice's state is in the first index.
            B_State = stringState[1] # Bob's state is in the second index.
            if A_State in states:
                if B_State in states:
                    newQWPang = Bob_QWP_RL_Settings[B_State]
                    oldQWPang = Bob_QWP_RL_Settings[self.Bob_QWP_pre_state]
                    if newQWPang != oldQWPang:
                        self.Move_Bob_QWP(str(B_State).upper())
                    # We can reach this state with the motors so move there
                    self.AHWP.move_to(str(A_State).upper())
                    self.AQWP.move_to(str(A_State).upper())
                    self.BHWP.move_to(str(B_State).upper()) 
                    # So that the delay does not start 
                    # until all the motors have moved to their proper location.

                    return True
                else:
                    raise ValueError("The value of the second index you entered is not a valid state")
            else:
                raise ValueError("The value of the first index is not a valid state")
        else:
            raise ValueError("The value you input is not a string. It is " + type(stringState))
    
    
    def reset(self):
        self.move_to("HH")
    
serial_numbers = [83811667, 83811904, 83811901, 83811664]    

Motors = AllMotors(serial_numbers)