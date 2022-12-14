# File Integrity Monitor (FIM)
File integrity monitoring (FIM) refers to an IT security process and technology that tests and checks operating system (OS), database, and application software files to determine whether or not they have been tampered with or corrupted.

This Project is performed using Windows PowerShell ISE. The main aim of this project is to notify the user if file has been changed, deleted or new file has been created using SHA-512 Cryptographic Hash Algorithm.

## Flow Chart
![FIM Flow Chart](https://user-images.githubusercontent.com/61871907/186584806-20817048-76d8-4236-96fe-588305b40f7b.jpg)

## Methodology 
### --> The user is prompted to choose "A" or "B" 
     [ i.e., A) Collect new Baseline?"
             B) Begin monitoring files with saved Baseline?" ]
     
### --> If the user enters "A", 
     + Baseline is deleted, if the Baseline already exists.
     + New Baseline is created.
     [ NOTE: Baseline is a text file which conatins the hashs of each file according to "Path | Hash" format, where "|" is the separator. ]
     
### --> If the user enters "B",
      Infinite loop has been created, which checks each second for the integrity of the files and notifies the user. 
     + The user is not notified if the there is no tampering of files.
     + A Dictionary is created, which hold the "File Path" as Key and "Hash" as Value from baseline.txt
     + Infinite Loop is run, in which it checks if the file has been tampered or not.
     
## Output
![output](https://user-images.githubusercontent.com/61871907/186590520-87af7dae-9cd9-49c6-bfc0-8466b9c3deb2.png)
