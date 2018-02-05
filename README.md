# terraform-sample
最近のterraformについて

#terraform

- 公式
  - https://www.terraform.io/
- 最新ver: 0.11.3
  - 更新が非常に速い

3秒でわかるterraform

## install

- binary
  - https://www.terraform.io/downloads.html

### 初期化

AWSにtfstateファイルを保存するバケットを作成

- IAM作成
  - アタッチするポリシーは`AdministratorAccess` でいい？
- S3バケット作成
  - bucket versioningつけること!!

```
-> % cat backend.tf
provider "aws" {
  region = "ap-northeast-1"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    bucket = "yoan-terraform"
    key    = "terraform.tf"
    region = "ap-northeast-1"
  }
}
```

```
$terraform init --var='access_keys=FOO' -var='secret_keys=BAR'

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (1.8.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 1.8"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### 環境を作成

0.10とかでは`env`だった

```
-> % terraform workspace new unstable
Created and switched to workspace "unstable"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

```
-> % terraform workspace show
unstable
```

```
-> % cat main.tf
data "aws_instance" "foo" {
  count = "${terraform.workspace == "unstable" ? 5 : 1}"
}
```

count=0にすることで「unstableでは作成しない。」ということも可能

## Tips

一部調べただけで試してないものもあります

### フォーマットを強制

オプションなしだと正しいフォーマットに強制的に書き換えます

```
$ terraform fmt
```

オプションつけると差分を表示する

```diff
-> % terraform fmt -write=false -diff=true
backend.tf
diff a/backend.tf b/backend.tf
--- /var/folders/ky/85lnsqz911n13lkhztgs20v0bs0pfq/T/423356597  2018-02-05 14:19:19.000000000 +0900
+++ /var/folders/ky/85lnsqz911n13lkhztgs20v0bs0pfq/T/318869648  2018-02-05 14:19:19.000000000 +0900
@@ -5,7 +5,7 @@
 terraform {
   required_version = ">= 0.11.3"

-             backend "s3" {
+  backend "s3" {
     bucket = "yoan-terraform"
     key    = "terraform.tf"
```

### 暗号化

#### KMSを利用する

https://www.terraform.io/docs/providers/aws/d/kms_secret.html

vaultを利用することもできるが未検証

### import

基本的なリソースはimportできる

```
terraform import ${tfファイルの定義名} ${instance-id}
```
