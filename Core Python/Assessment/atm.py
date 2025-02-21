import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import json
class atm:
    def __init__(self,name):
        self.tirth=f"{name}.json"
        self.pin=""
        self.balance=0
        self.email=""
        self.load_data()
        self.menu()
        
    def load_data(self):
        """Load PIN and balance from a JSON file."""
        try:
            with open(self.tirth, "r") as file:
                data = json.load(file)
                self.pin = data.get("pin", "")
                self.balance = data.get("balance", 0)
                self.email=data.get("email","")
        except (FileNotFoundError, json.JSONDecodeError):
            self.pin = ""
            self.balance = 0
            self.email=""
            self.save_data()
            

    def save_data(self):
        """Save PIN and balance to a JSON file."""
        with open(self.tirth, "w") as file:
            data = {"pin": self.pin, "balance": self.balance,"email":self.email}
            json.dump(data, file)
    
    def menu(self):
        user_input=input("""
                         press 1 for create pin
                         press 2 for change pin
                         press 3 for deposite money
                         press 4 for check balance
                         press 5 for widthrawl
                         press 6 for exit 
                         
                         """) 
        if user_input=="1":
            self.create_pin()
        elif user_input=="2":
            self.change_pin()   
        elif user_input=="3":
            self.deposit()    
        elif user_input=="4":
            self.checkbalance()    
        elif user_input=="5":
            self.withdrawl()    
        else:
            exit()
        
    def create_pin(self):
        print(len(self.pin))
        if len(self.pin)==0:    
            user_pin=input("enter your pin")
            self.pin=user_pin  
            print("pin create successfully")
            self.save_data()
            self.menu()   
        else:
            print("your pin is already created")  
            self.menu()   
              
    def create_npin(self):
        
         
        user_pin=input("enter your pin")
        self.pin=user_pin  
        print("pin create successfully")
        self.save_data()  
        self.menu() 
             
        
    def change_pin(self):
        oldpin=input("enter yout old pin if you forgot to type forgot")
        if oldpin=="forgot":
            self.otp()
            self.create_npin()
        elif oldpin==self.pin:
            newpin=input("enter your new pin")
            self.pin=newpin
            print("your pin change successfully")
            self.save_data()
            self.menu() 
        else:
            print("youe pin is wrong")  
            self.change_pin()  
            
    def deposit(self):
        pin=input("enter your pin for deposit")
        if self.pin==pin:
            amount=int(input("enter your amount"))
            self.balance+=amount
            self.save_data()
            check=input("are you want to check balance say yea or no")
            if check=="yes":
                self.checkbalance()
            else:
                self.menu()
            
    def checkbalance(self):
        pin=input("enter your pin for checkbalance")
        if self.pin==pin:
            print(self.balance)
            self.menu()
        else:
            print("please enter coreect pin")
            ck=input("if you want to cancel enter cancel")
            if ck=="cancel":
                self.menu()
            else:
                self.checkbalance()     
    def withdrawl(self):
        pin=input("enter your pin for withdrawl")
        if self.pin==pin:
            if self.balance!=0:
                try:
                    amount=int(input("enter your amount for withdrawl"))
                    if amount>self.balance:
                        raise ValueError("you not have sufficient amount!")
                    if amount==0:
                        raise ValueError("you nete 0 amount")
                except ValueError as e:
                    print(f"Error: {e}")
                    
                self.balance-=amount
                self.save_data()
                check=input("are you want to check balance say yea or no")
                if check=="yes":
                    self.checkbalance()
                else:
                    self.menu()  
            else:
                print("youe account is empty pleae deposite money") 
                self.menu()           
    def otp(self):
                    def generate_otp():
                        return random.randint(100000, 999999)

                    # Function to send OTP via email
                    def send_email_otp(receiver_email, otp):
                        try:
                            # Your email credentials
                            sender_email = "tp338096@gmail.com"  # Replace with your email
                            sender_password = "amwa xigw vdrd fcxk"     # Replace with your email app password

                            # Email subject and body
                            subject = "Your OTP Code"
                            body = f"Your OTP code is: {otp}. Please do not share it with anyone."

                            # Email message setup
                            message = MIMEMultipart()
                            message['From'] = sender_email
                            message['To'] = receiver_email
                            message['Subject'] = subject
                            message.attach(MIMEText(body, 'plain'))

                            # SMTP server connection
                            with smtplib.SMTP("smtp.gmail.com", 587) as server:
                                server.starttls()  # Secure the connection
                                server.login(sender_email, sender_password)
                                server.sendmail(sender_email, receiver_email, message.as_string())
                                print(f"OTP sent successfully to {receiver_email}")
                        except Exception as e:
                            print(f"Error sending OTP: {e}")

                    # Main function
                    def main():
                        if not self.email:
                            self.email = input("Enter the recipient's email address: ")
                            self.save_data()
                        otp = generate_otp()
                        send_email_otp(self.email, otp)
                        
                        # Verify OTP
                        user_otp = input("Enter the OTP sent to your email: ")
                        if str(user_otp) == str(otp):
                            print("OTP verified successfully!")
                        else:
                            print("Invalid OTP. Please try again.")

                    if __name__ == "__main__":
                        main()

# ur=atm()    
name=input("please enter your name")
pr=atm(name)