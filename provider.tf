terraform {
  backend "s3" {
    bucket = "t3msp"                         # 공용 object strorage 의 이름 = t3msp 고정값
    key    = "jinyoung.son/mgmt/terraform.tfstate"  # ex) abc.123
    #endpoint = "https://obj1.kr-east-1.scp-in.com:8443"     # object storage가 생성된 private endpoint
    endpoint = "https://obj1.kr-east-1.samsungsdscloud.com:8443"     # object storage가 생성된 pub endpoint
    region = "None"
    skip_region_validation=true
    skip_credentials_validation=true
    skip_metadata_api_check=true
    force_path_style=true
    profile="scp"
  }
  
  required_providers {
    scp = {
      version = "2.3.1"
      source = "SamsungSDSCloud/samsungcloudplatform"
    }
  }
  required_version = ">= 0.13"
}

provider "scp" {
}

