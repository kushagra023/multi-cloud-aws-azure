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
  subscription_id = "bac106ec-b599-4bb8-bc6a-487908e25a33"
}
