# Guide d'Installation - Infrastructure Docker Multi-VM

Ce dépôt contient l'ensemble des configurations pour déployer une architecture distribuée (App, Log, Monitoring) sur 3 VMs via Docker et Traefik.

## 1. Pré-requis
- 3 VMs (Lima, VirtualBox ou Cloud) sous Debian/Ubuntu.
- Docker et Docker Compose installés sur chaque nœud.
- Un accès réseau entre les VMs.

### Ouverture des Ports
| Machine | Rôle | Ports à ouvrir |
| :--- | :--- | :--- |
| **VM1** | Application | `8443` (HTTPS) |
| **VM2** | Logging | `8444` (Kibana), `8090`, `5040` (Logstash) |
| **VM3** | Monitoring | `8445` (Uptime Kuma) |

---

## 2. Déploiement technique

### VM1 — Application (WordPress, Keycloak, PMA)
1. Placez le contenu de `VM1-APP` dans `~/`.
2. Installez les outils de chiffrement : `sudo apt install apache2-utils`.
3. Générez vos accès Traefik : `htpasswd -nbB user password >> ~/traefik/basic-auth/users`.
4. Configurez les fichiers `.env` dans les dossiers `wordpress/` et `keycloak/`.
5. Lancez l'installation : `./script.sh`.

### VM2 — Logging (Stack ELK)
1. Placez le contenu de `VM2-LOGGING` dans `~/`.
2. Lancez les services : `docker compose up -d`.

### VM3 — Monitoring (Uptime Kuma)
1. Placez le contenu de `VM-MONITORING` dans `~/`.
2. **Configuration cruciale** : Pour permettre à Uptime Kuma de résoudre les domaines `.local` des autres VMs, éditez le `docker-compose.yml` et ajoutez la section `extra_hosts` *192.168.5.2 correspondant à l'IP partagé par défaut de lima à éditer au besoin* :
   ```yaml
   extra_hosts:
     - "keycloak.local:192.168.5.2"
     - "pma.local:192.168.5.2"
     - "wordpress.local:192.168.5.2"
     - "kibana.local:192.168.5.2"
   ```
3. Lancez les services : `cd monitoring/ && docker compose up -d`.

---

## 3. Accès aux Services (Configuration Hôte)
Ajoutez ces entrées dans le fichier `/etc/hosts` de votre machine physique (ordinateur) pour accéder aux interfaces en modifiant les IP:
- `IPVM1 keycloak.local`
- `IPVM1 traefik.local`
- `IPVM1 pma.local`
- `IPVM1 wordpress.local`
- `IPVM2 kibana.local`
- `IPVM3 uptime.local`
