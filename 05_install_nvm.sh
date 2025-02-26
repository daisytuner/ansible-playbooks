# Install NVM
for i in {30..41}
do
    ssh -t "daisy@192.168.0.$i" 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
    ssh -t "daisy@192.168.0.$i" "bash -i -c 'nvm install 20 && nvm alias default 20'"
done

# Install runner
for i in {30..41}
do
    scp /home/daisy/.npmrc "daisy@192.168.0.$i":~/
    ssh -t "daisy@192.168.0.$i" "bash -i -c 'npm install -g @daisytuner/runner'"
done
