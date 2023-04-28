

A Simple FIM (File Integrity Monitor) using powershell



## PowerShell Script for Monitoring File Changes

This PowerShell script provides users with the option to either collect a new baseline for files in a target folder or begin monitoring files in the target folder with a saved baseline. 

### Functions

The script contains two functions:

1. `Calculate-File-Hash` - This function calculates the SHA512 hash of a file and returns it. It takes the file path as a parameter.

2. `Erase-Baseline-If-Already-Exists` - This function checks if a `baseline.txt` file already exists in the current directory and deletes it if it does.

### Option A: Collect New Baseline

If the user selects option A, the script will call the `Erase-Baseline-If-Already-Exists` function to delete any existing `baseline.txt` file. Then, it will collect all the files in the `Files` directory (located in the current directory). For each file, it will calculate the hash using the `Calculate-File-Hash` function and write it to `baseline.txt` in the format of `filepath|hash`. 

### Option B: Begin Monitoring Files

If the user selects option B, the script will first load the file paths and hashes from `baseline.txt` into a dictionary. It will then continuously monitor the files in the `Files` directory for changes using an infinite loop. 

For each file in the directory, the script will calculate the hash using the `Calculate-File-Hash` function. If the hash does not exist in the dictionary, it means that a new file has been created, and the script will notify the user by printing the file path in green. If the hash exists in the dictionary, it will compare the hash values. If they are the same, it means that the file has not been changed. If they are different, it means that the file has been modified, and the script will notify the user by printing the file path in yellow.

The script will also check if any files in the dictionary have been deleted by checking if the file path still exists. If it does not exist, it means that the file has been deleted, and the script will notify the user by printing the file path in red.

The script will sleep for one second between iterations of the loop to avoid excessive resource usage.

## If Scripting is not enabled by default in Powershell execute the following command.
```
Set-ExecutionPolicy RemoteSigned
```


# This is the flowchart for FIM

![FIM Flow Chart](https://user-images.githubusercontent.com/73808898/213779665-b1880d78-8150-40ae-95cf-0ebc6bc24ae3.jpg)




## The folder structure consists
- FIM
- Folder conataining testing files

## The Output of the script 
![Pasted image 20230120235947](https://user-images.githubusercontent.com/73808898/213779687-0977083c-a714-4471-9d91-69fd7961312e.png)


