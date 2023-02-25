if has("wsl")
    let path = $PATH
    let path_directories = split(path, ":")
    let linux_only_directories = filter(
                \ path_directories,
                \ { index, val -> val !~ "windows" && val !~ "wsl" && val !~ "Program Files" }
                \ )
    let linux_only_path = join(linux_only_directories, ":")
    let $PATH = linux_only_path
endif
