# Place this in your .zshrc file to have a permanent alias to easily switch a Kubernetes namespace

kns() {
    local contextFlag="--current"
    local namespace=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--context)
                if [[ -z "$2" ]]; then
                    echo "Usage: kns [-c|--context <context>] <namespace>"
                    return 1
                fi
                contextFlag="$2"
                shift 2
                ;;
            *)
                if [[ -z "$namespace" ]]; then
                    namespace="$1"
                else
                    echo "Usage: kns [-c|--context <context>] <namespace>"
                    return 1
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$namespace" ]]; then
        echo "Usage: kns [-c|--context <context>] <namespace>"
        return 1
    fi

    kubectl config set-context $contextFlag --namespace="$namespace" && \
    kubectl get namespaces | grep -q "^$namespace " && \
    echo "Namespace set to $namespace" || \
    echo "Failed to set namespace to $namespace"
}