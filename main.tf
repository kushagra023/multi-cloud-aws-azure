terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "Administrator"
}

provider "azurerm" {
  features {}
}
