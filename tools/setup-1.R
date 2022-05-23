# run this script within the new package after rdev::create_github_repo
gert::git_branch_create("package-setup")
gert::git_add(".")
gert::git_commit("rdev::create_github_repo()")
gert::git_push()
rdev::use_rdev_package()
