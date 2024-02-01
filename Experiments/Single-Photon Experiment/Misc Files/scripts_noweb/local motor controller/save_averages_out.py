# This is a script to write the output dictionary to a csv file
# Not done yet

import csv
import os
import datetime as dt

date = dt.date.today() # Today's date is held in date.

experiments = { # A dictionary of all the experiments and the order in which
    # the states for that measurement should be presented.
    "Full_Tomography": ["HH", "VV", "HV", "VH", "DD", "AA", "DA", "AD", "RR",
    "LL", "RL", "LR", "HD", "VA", "HA", "VD", "HR", "VL", "HL", "VR", 
    "DH","AV", "DV", "AH", "DR", "AL", "DL", "AR", "RH", "LV", "RV", "LH",
    "RD", "LA", "RA", "LD"],
    "Purity": ["DD", "AA", "DA", "AD"],
    "HV_Basis": ["HH", "VV", "HV", "VH"],
    "Steering": ["DS","AS", "DZ", "AZ", "DB", "AB", "DP", "AP", 
    "HH", "VV", "HV", "VH", "DD", "AA", "DA", "AD", "SD", "SA", "ZD", "ZA",
    "BD", "BA", "PD", "PA"], # B = sailboat state P = sailboat perpendicular
    # S = smilely face state and Z = smilely face perpendicular state.
    "Circular": ["RR", "LL", "LR", "RL"] }
        
headers = ["State", "Coincident Counts Average", "Coincident Counts Uncertainty"]

def save(outputdict, savefilepath, headers, experimentname):
    orderedstates = experimenttype(experimentname, outputdict)
    with open(savefilepath, "w+", newline = "\n") as csvfile:
        if len(headers) != 0:
            writehead(csvfile, headers, experimentName) 
            # Write the first row as headers
        loopcount = 0
        probBool = False
        singleBasis = ['Circular', 'HV_Basis', 'Purity']
        if experimentName in singleBasis:
            probBool = True
            total = sum(orderedstates.values())
            # These experiments only have 1 basis
        for state in orderedstates:
            row = ""
            loopcount += 1 
            # Increment Loop count so that the data can be more easily read.
            if loopcount%4 == 0 and loopcount != 0:
                # Add an extra newline for readability to separate the states
                # by basis. It also enables easy data transfer to Summer_2018
                # which holds the full tomography calculations.
                row += "\n"
            row += str(state)
            data = "" # A blank string to hold the data to be separated by ','
            for x in outputdict[state]:
                data += "," + str(x)
                if probBool:
                    data += "," + str(x/total)
                    #Probability is that states counts/all counts in the basis.
            row += data + "\n"
            csvfile.write(row)

        csvfile.close() # We are done writing to the file so close it.
        # This way it can be opened in other editors like Excel or Origin.
    return

def getStateName():
    while True:
        try:
            entry = input('What is the name of the state you made?')

            name = str(entry)
            
            while "." in name:
                name = name.replace(".", "_")
            break
        except ValueError:
            print('Not a valid state name')
        print()
    return name    
        
def saveData(outputdict, experimentname):
    basePath = "C:\\users\\lynnlab\\Desktop" 
    # Always start at the desktop so that the file can be easily found later.
    stateName = getStateName()
    filename = stateName + "-" + experimentName + " " + date.isoformat()
    currtime = dt.datetime.now().time() # HH:MM:SS.microseconds
    filename += currtime + ".csv"
    savefilepath = os.path.join(basePath, filename)
    save(outputdict, savefilepath, headers, experimentname)
    return
        
def writehead(csvfile, headers, experimentName):
    linetowrite = ""
    singleBasis = ['Circular', 'HV_Basis', 'Purity']
    if experimentName in singleBasis:
        headers += "Probability of this State"
    for x in headers:
        linetowrite += x + ","
    linetowrite += "\n" 
    # Add a newline character at the end 
    # so that the data will be below the headers.
    csvfile.write(linetowrite)
    
def experimenttype(experimentname, outputdict):
    """ This function takes in a string and returns the desired output list of 
    states in the order determined based upon the experiment name """
    
    if experimentname in experiments.keys():
        return experiments[experimentname]
    else:
        return outputdict.keys()
