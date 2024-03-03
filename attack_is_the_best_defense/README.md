# Attack is the best defense

### Task 0
So this is how I did task 0:
1.  I downloaded the file which we were asked to download: ` user_authenticating_into_server`. I believe the steps were scripted and the compiled to that file because opening it you find nothing readable. I change the permissions with `chmod u+x user_authenticating_into_server` so that it could be executed.

2. Then sniffing using: `sudo tcpdump -i eth0 -v port 587 -A`:
This command uses `tcpdump`, a command-line network packet analyzer, to capture and display network traffic on a specific interface (`-i`) and with specific filter parameters (`port 587` and `-A`).

    Here's what each part of the command does:

    - `sudo`: This command runs `tcpdump` as a superuser, allowing it to capture packets on the network interface. This is necessary because capturing network packets requires elevated privileges.

    - `tcpdump`: This is the command-line tool for capturing network packets.

    - `-i eth0`: This specifies the network interface to capture packets from. In this case, it's `eth0`, which is a common name for the first Ethernet interface on a Linux system.

    - `-v`: This makes `tcpdump` print detailed information about each packet, including protocol headers.

    - `port 587`: This is a filter expression that tells `tcpdump` to capture packets that are sent to or from port 587. Port 587 is the default port for the SMTP submission service, which is used for sending email messages.

    - `-A`: This specifies that `tcpdump` should print the ASCII representation of the packet payload (the actual data being sent over the network). This makes it easier to read the content of the captured packets.

    The command as a whole captures network traffic on the `eth0` interface, filters it to include only packets related to port 587 (SMTP submission), and prints detailed information about each packet, including the ASCII representation of the packet payload. The `sudo` command is used to ensure that `tcpdump` has the necessary permissions to capture packets.

So running the above command somewhere (in a instance of the WSL) and excuting the file downloaded in another instance of the WSL I was using I was able to monitor the transfers while the file ` user_authenticating_into_server` run/executed.

The codes there were Base64-encoded so decoding some of them made sense, which consequently lead to the realization of the password. Example:
- The Base64-encoded string `VXNlcm5hbWU6` decodes to the plaintext string `Username:`.
Following the input that was given after this, when decoded gives you the username that was entered, in plaintext.
- The Base64-encoded string `UGFzc3dvcmQ6` decodes to the plaintext string `Password:`. 
Similarly, following the input that was given after this, when decoded gives you the password that was entered, in plaintext.

### Task 1
So this is how I did task 1:
- I downloaded some common passwords lists but `rockyou.txt` worked out.
And after following the instructions given in the task, that is pulling and running the Docker image `sylvainkalache/264-1` with the command `docker run -p 2222:22 -d -ti sylvainkalache/264-1`, this was the command I used in attaining the password using `hydra` through the `ssh` service:
`hydra -l sylvain -P rockyou.txt
 127.0.0.1 -s 2222 ssh -o output.txt -F`.
 ```hydra -l <username> -p <passwordlist.txt> -s <portnumber> <service> -o <outputfile> -F```


    In this command:

    - `-l sylvain`: Specifies the username to use for the attack. `-L <usernamelist>` if you have a list of usernames in a file where `<usernamelist>` is the path to the username wordlist.
    - `-P rockyou.txt`: Specifies the path to the password wordlist (rockyou.txt). `-p <password>` if you know the password before hand.
    - `127.0.0.1`: Specifies the target IP address.
    - `-s 2222`: Specifies the SSH port (2222).
    - `ssh`: Specifies the target protocol (SSH) or the service used.
    - `-o output.txt`: Specifies where the output of the attack shoudl be recorded.
    
This command will use Hydra to perform a brute-force attack on the SSH service running on port 2222 of the target IP address (127.0.0.1). The attack will use the username sylvain and passwords from the rockyou.txt wordlist. The results of the attack will be stored in the output.txt file.