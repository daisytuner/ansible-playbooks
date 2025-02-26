for i in {30..41}
do
    ssh -t "daisy@192.168.0.$i" "mkdir .credentials"
    scp /home/daisy/.credentials/firebase.json "daisy@192.168.0.$i":~/.credentials/
    ssh -t "daisy@192.168.0.$i" 'echo "export FIREBASE_APPLICATION_CREDENTIALS=/home/daisy/.credentials/firebase.json" >> .bashrc'
done
