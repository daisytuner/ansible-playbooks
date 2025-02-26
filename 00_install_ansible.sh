for i in {30..42}
do
    ssh -t "daisy@192.168.0.$i" 'sudo apt-get install -y python3-pip && echo "export PATH=/home/daisy/.local/bin:$PATH" >> /home/daisy/.bashrc && pip install ansible --break-system-packages'
done

