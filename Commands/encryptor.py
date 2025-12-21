def Encrypt(text, key):
    keyValues = []
    for letters in key:
        keyValues.append(ord(letters))
    
    textValues = []
    for letters in text:
        textValues.append(ord(letters))
    
    finalValues = []
    for i in range(len(textValues)):
        newValue = 0
        if i == 0: 
            newValue = textValues[i] + keyValues[i]
        else: 
            newValue = textValues[i] + keyValues[i % len(keyValues)]

        finalValues.append(str(newValue))
    
    encryptedText = ".".join([str(value) for value in finalValues])

    print("Encrypted text: " + encryptedText)
    return

def Decrypt(text, key):
    textValues = text.split(".")
    keyValues = []
    for letters in key:
        keyValues.append(ord(letters))
    
    ordValues = []
    for i in range(len(textValues)):
        newValue = 0
        if i == 0: 
            newValue = int(textValues[i]) - keyValues[i]
        else: 
            newValue = int(textValues[i]) - keyValues[i % len(keyValues)]
        
        ordValues.append(int(newValue))
    
    finalValues = []
    for value in ordValues:
        finalValues.append(chr(value))

    decryptedText = "".join([str(value) for value in finalValues])
    print("Decrypted text: " + decryptedText)
    return 


key = ''
while len(key) <= 0:
    key = input("Input a key... ")

text = ''
while len(text) <= 0:
    text = input("Input a text... ")

action = ""
while True:
    action = input("Encrypt or Decrypt? (0 / 1) ")
    if action == "0" or action == "1": break

if(action == "0"): Encrypt(text, key)
else: Decrypt(text, key)