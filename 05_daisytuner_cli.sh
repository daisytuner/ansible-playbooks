for i in {10..16}
do
    # install snap
    scp daisytuner-cli_0.0.1_arm64.snap "daisy@192.168.0.$i":~/
    ssh -t "daisy@192.168.0.$i" "sudo snap install daisytuner-cli_0.0.1_arm64.snap --dangerous"

    # configure credentials
    scp -r /home/daisy/.credentials "daisy@192.168.0.$i":/var/snap/daisytuner-cli/common/
    ssh -t "daisy@192.168.0.$i" "sudo chown root:root /var/snap/daisytuner-cli/common/.credentials/*"
    ssh -t "daisy@192.168.0.$i" "sudo chmod 600 /var/snap/daisytuner-cli/common/.credentials/*"

    # prepare jobs output
    ssh -t "daisy@192.168.0.$i" "sudo mkdir -p /var/snap/daisytuner-cli/common/jobs && sudo chmod 777 /var/snap/daisytuner-cli/common/jobs"
done
