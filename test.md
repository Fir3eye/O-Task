WordPress Deploy Using Ansible 
===========================

Working Step:-

			1. Create Two EC2 Instance (t2.micro)
			2. Create User on Worker/ Node
			3. Give Root Privileges of Both Worker and Node 
			4. Generate SSH Key on Worker Node 
			5. Copy SSH Key on Node 
			6. Clone the Repository
			7. Install Ansible
			8. Go to Playbook Directory
			9. Apply Playbook 
			10. Check on Browser
		
Implementation:-

	Create Two EC2 Instance (t2.micro)	
	Create User on Worker/ Node	sudo adduser ansible
		Note:- specify password both(worker/Node) side
	Give Root Privileges of Both Worker and Node 	visudo
		ansible ALL=(ALL)  NOPASSWD:ALL
	Generate SSH Key on Worker Node 	ssh-keygen
		 
	Copy SSH private Key on Node 	ssh-copy-id ansible@IP
	Clone the Repository	git clone https://github.com/Fir3eye/ansible-playbooks.git
	Install Ansible	sudo apt update
		sudo apt install ansible
		ansible --version
	Go to Playbook Directory	cd wordpress-lamp_ubuntu1804
	Chagne the hosts	Your_server_Private_IP
	Apply Playbook 	Ansible-playbook playbook.yml -I hosts -u ubuntu 
	Check on Browser	Copy our public server ip on brower
![image](https://github.com/Fir3eye/O-Task/assets/93431222/a6d05579-1ec3-432e-86f1-56049cb26277)
