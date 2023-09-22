import json
import subprocess
import sys

def run_shell_command(command):
    try:
        # Execute the shell command and capture the output
        result = subprocess.run(command, shell=True, capture_output=True, text=True)

        # Check if the command executed successfully
        if result.returncode == 0:
            # Print the output of the command
            print("Command output:")
            print(result.stdout)
        else:
            # Print the error message if the command failed
            print("Command execution failed with error:")
            print(result.stderr)

    except Exception as e:
        print(f"Error: {e}")


def main():
    args = sys.argv[1:]
    fsname = ""

    # Check if any arguments were passed
    if len(args) == 0:
        print("python3 fsname.py <<KnoxID>> 를 입력해주세요")
    else:
        run_shell_command("aws s3 cp s3://t3msp/{0}/mgmt/terraform.tfstate . --endpoint-url https://obj1.kr-east-1.samsungsdscloud.com:8443 --profile scp".format(args[0]))

        #terraform.tfstate 파싱
        try:
            with open('terraform.tfstate', 'r') as f:
                content = f.read()
                parsed = json.loads(content)["resources"]
                for item in parsed:
                    if item["type"] == "scp_file_storage" :
                        fsname = item["instances"][0]["attributes"]["file_storage_name"]

            print("parsed name:",fsname)
            # output_value 값을 tfvars 파일에 저장
            if fsname != "" :
                with open('terraform.tfvars', 'w') as f:
                    f.write(f'file_storage_name = "{fsname}"')

        except FileNotFoundError:
            print("terraform.tfstate not found")



####### main starts here #########

if __name__ == "__main__":
    main()