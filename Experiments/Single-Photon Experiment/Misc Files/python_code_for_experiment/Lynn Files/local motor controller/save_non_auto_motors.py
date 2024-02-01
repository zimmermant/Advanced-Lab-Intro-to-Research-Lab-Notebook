import os
from ccu_record_to_a_given_file import measure
import purity_test

def getPlateName():
    # Ask the user to input the name of the plate to be turned.
    while True:
        try:
            entry = input('What is the name of the plate you will be turning?')
            name = str(entry)
            break
        except ValueError:
            print('not a valid integer')
        print()
    return name

def getNumSamples():
    """ This portion of the code was written by Kye Shi so that it
     can interface with the ccu_record.py file."""
    while True:
        try:
            print('# of samples (pass 0 to collect indefinitely):')
            entry = input('(default: 0) > ')
            if not entry:
                samples = 0

            samples = int(entry)

            if samples < 0:
                print('must be non-negative')
                continue

            break
        except ValueError:
            print('not a valid integer')
        print()
    return samples
	
def setupAngleSweep():
    print('select start angle:')
    start = 0
    while True:
        try:
            entry = input('(default: 0) > ').strip()

            if not entry:
                break

            start = float(entry)
            break

        except ValueError:
            print('please enter a valid number')

    print()

    print('select end angle:')
    end = 180
    while True:
        try:
            entry = input('(default: 180)> ').strip()

            if not entry:
                break

            end = float(entry)

            if end <= start:
                print('end angle must be greater than start angle')
                continue

            break
        except ValueError:
            print('please enter a valid number')

    print()

    print('select step size:')
    step = 5
    while True:
        try:
            entry = input('(default: 5) > ').strip()

            if not entry:
                break

            step = float(entry)

            if step <= 0:
                print('step angle must be positive')
                continue

            break

        except ValueError:
            print('please enter a valid number')
    return [start, end, step]

def clean(output):
    # Eliminate the decimal points in the filename assume
    # no file extension in the name.
    while "." in output:
        output = output.replace(".", "_")
    return output

def buildFilenamehead():
    samplenum = getNumSamples()
    angleSet = setupAngleSweep()
    name = getPlateName()
    output = str(name) + " " + str(samplenum) + "samples " 
    output += str(angleSet[0]) + " to " + str(angleSet[1]) + " step "
    output += str(angleSet[2]) + " at "
    output = clean(output)
    return [output, angleSet, samplenum, name]
    
def main():
	# This will run once at the beginning.
    baseFilename = os.getcwd()
    baseFilename = os.path.dirname(baseFilename) # go back 1 folder
    baseFilename = os.path.join(baseFilename, "measurements\\recalibration")
    outofbuild = buildFilenamehead()
    baseFilename = os.path.join(baseFilename, str(outofbuild[0]))
    return [baseFilename, outofbuild]

def Move_Plate(PlateName, AngleToGoTo):
    print("As a reminder: "+str(PlateName)+ " should be at: "+str(AngleToGoTo))
    ready_to_record = False
    while(ready_to_record  != True):
        userin=input(str(PlateName)+" at "+str(AngleToGoTo)+" degrees? y/n ")
        try:
            if str(userin) == "y":
                # Set the loop condition to exit.
                ready_to_record = True
        except:
            print("Please try again. What you input was not valid.")
            
            
def LIST_ANGLES(start, end, step):
    curr = start # Mod the start angle by 360
    # Assume that steps will get you to the end from start
    end = end
    step = step
    output = []
    while curr != end:
        output += [curr]
        curr = (curr+step)
        if curr >= end:
            curr = end
    output += [end]
    return output
    
def loop():
    outofmain = main()
    start = outofmain[1][1][0] # This is the location of the start angle
    end = outofmain[1][1][1]
    step = outofmain[1][1][2]
    angles = LIST_ANGLES(start, end, step)
    print("This is the list of the angles")
    print(angles)
    numsamples = outofmain[1][2]
    baseFilename = outofmain[0]
    PlateName = outofmain[1][3]
    for x in angles:
        Move_Plate(PlateName, x)
        x = str(x)
        x = x.replace(".", "_")
        fileend = "currently at " + str(x) + ".csv"
        direct = os.path.split(baseFilename) # The directory name is in output 0
        basePath = direct[1] + fileend
        print("This is the current location you are saving to")
        print(basePath)
        
        
        save_file_path.makeDir(basePath) # Recursively make the necessary folders.
        """
        
        directory = os.path.split(baseFilename)[0]
        try: 
            os.mkdir(directory)
        except OSError:
            if not os.path.isdir(directory):
                raise # This should raise the OSError that was caught.
        basePath = os.path.join(directory, basePath)
        with open(basePath, "w+") as file:
            # Warning this will overwrite any file that his been already created.
            # which should not happen because every file should have a unique name.
            # It is not entirely guaranteed for the files to have unique names
            # unless only one computer is running the script at a time.
            file.close()
        
        # Call the record function with the appropriate file location.
        
        Currently unnecessary
        """
        
        #measure(numsamples, basePath)
        purity_test.purityTest()
loop()
       