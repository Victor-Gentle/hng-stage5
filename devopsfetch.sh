#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"

get_active_ports() {
    echo -e "Port\tService"
    sudo netstat -tuln | awk 'NR>2 {print $4 "\t" $6}' | awk -F ":" '{print $NF "\t" $2}' | column -t
}

get_port_info() {
    local port=$1
    echo "Information for port $port:"
    sudo netstat -tuln | grep ":$port " | awk '{print "Port: " $4 "\nService: " $6}' | column -t -s $'\t'
}

get_docker_info() {
    echo -e "REPOSITORY\tTAG\tIMAGE ID\tCREATED\tSIZE"
    sudo docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}"
    echo -e "\nCONTAINER ID\tIMAGE\tCOMMAND\tCREATED\tSTATUS\tPORTS\tNAMES"
    sudo docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"
}

get_container_info() {
    local container_name=$1
    echo "Information for container $container_name:"
    sudo docker inspect $container_name | jq '.[] | {ID: .Id, Image: .Config.Image, Command: .Config.Cmd, Created: .Created, Status: .State.Status, Ports: .NetworkSettings.Ports}'
}

get_nginx_info() {
    echo -e "Domain\tPort"
    for site in /etc/nginx/sites-available/*; do
        domain=$(grep -oP '(?<=server_name ).*(?=;)' $site)
        port=$(grep -oP '(?<=listen ).*(?=;)' $site)
        echo -e "$domain\t$port"
    done | column -t
}

get_nginx_domain_info() {
    local domain=$1
    for site in /etc/nginx/sites-available/*; do
        if grep -q "server_name $domain" $site; then
            echo "Configuration for domain $domain:"
            cat $site
            return
        fi
    done
    echo "No configuration found for domain: $domain"
}

get_user_info() {
    echo -e "Username\tLast Login"
    last -a | awk '{print $1 "\t" $4, $5, $6, $7, $8, $9}' | column -t
}

get_user_detail() {
    local username=$1
    echo "Information for user $username:"
    last -a $username | awk '{print $1 "\t" $4, $5, $6, $7, $8, $9}' | column -t
}

display_activities_in_time_range() {
    local since=$1
    local until=$2
    echo "Activities from $since to $until:"
    sudo journalctl --since="$since" --until="$until" | column -t
}

monitor_activities() {
    while true; do
        {
            echo "Monitor log at $(date):"
            echo "Active Ports and Services:"
            sudo netstat -tuln | awk 'NR>2 {print $4 "\t" $6}' | awk -F ":" '{print $NF "\t" $2}' | column -t
            echo
            echo "Docker Images:"
            sudo docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}"
            echo
            echo "Docker Containers:"
            sudo docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"
            echo
            echo "Nginx Domains and Ports:"
            for site in /etc/nginx/sites-available/*; do
                domain=$(grep -oP '(?<=server_name ).*(?=;)' $site)
                port=$(grep -oP '(?<=listen ).*(?=;)' $site)
                echo -e "$domain\t$port"
            done | column -t
            echo
            echo "Users and Last Login Times:"
            last -a | awk '{print $1 "\t" $4, $5, $6, $7, $8, $9}' | column -t
            echo
        } >> "$LOG_FILE"
        sleep 300
    done
}

show_help() {
    cat << EOF
Usage: devopsfetch [options]

Options:
    -p, --port <port_number>       Display information about a specific port
    -d, --docker [container_name]  List all Docker images and containers, or information about a specific container
    -n, --nginx [domain]           List all Nginx domains and ports, or information about a specific domain
    -u, --users [username]         List all users and their last login times, or information about a specific user
    -t, --time <since> <until>     Display activities within a specified time range
    --monitor                      Run in continuous monitoring mode
    -h, --help                     Show this help message
EOF
}

case "$1" in
    -p|--port)
        get_port_info $2
        ;;
    -d|--docker)
        if [ -z "$2" ]; then
            get_docker_info
        else
            get_container_info $2
        fi
        ;;
    -n|--nginx)
        if [ -z "$2" ]; then
            get_nginx_info
        else
            get_nginx_domain_info $2
        fi
        ;;
    -u|--users)
        if [ -z "$2" ]; then
            get_user_info
        else
            get_user_detail $2
        fi
        ;;
    -t|--time)
        if [ -z "$3" ]; then
            show_help
        else
            display_activities_in_time_range $2 $3
        fi
        ;;
    --monitor)
        monitor_activities
        ;;
    -h|--help)
        show_help
        ;;
    *)
        show_help
        ;;
esac
