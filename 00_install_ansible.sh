for i in {10..16}
do
    ssh -t "daisy@192.168.0.$i" 'sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get install -y python3-pip && echo "export PATH=/home/daisy/.local/bin:$PATH" >> /home/daisy/.bashrc && pip install ansible --break-system-packages'
done
