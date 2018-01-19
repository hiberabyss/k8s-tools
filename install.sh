#!/bin/sh
# Author            : Hongbo Liu <hbliu@freewheel.tv>
# Date              : 2018-01-18
# Last Modified Date: 2018-01-18
# Last Modified By  : Hongbo Liu <hbliu@freewheel.tv>

dest_dir="$HOME/bin"

prepare_path() {
    mkdir -p $dest_dir

    if [[ ! "$PATH" =~ $dest_dir ]]; then
        export PATH=$PATH:$dest_dir
        echo 'export PATH=$PATH:$HOME/bin' | tee -a ~/.bashrc ~/.zshrc
    fi
}

do_exist() {
    if which $1 &> /dev/zero; then
        return 0
    fi
    return 1
}

install_kubectl() {
    kubectl_bin="$1"
    sudo wget -qO $kubectl_bin "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo chmod +x $kubectl_bin
}

precheck() {
    if ! do_exist git; then
        sudo yum install -y git
    fi

    if ! do_exist zsh; then
        sudo yum install -y zsh
    fi

    if ! do_exist kubectl; then
        install_kubectl /usr/local/bin/kubectl
    fi
}

get_file() {
    url="$1"
    filename="$2"
    wget -qO "$dest_dir/$filename" $url
    chmod +x $dest_dir/$filename
}

main() {
    prepare_path
    precheck

    get_file "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens" kns
    get_file "https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx" kctx
    get_file "https://raw.githubusercontent.com/hiberabyss/dotfiles/master/link/bin/kexe" kexe
    get_file "https://raw.githubusercontent.com/hiberabyss/dotfiles/master/link/bin/kget" kget
    get_file "https://raw.githubusercontent.com/ahmetb/kubectx/master/utils.bash" utils.bash
}

main $@
