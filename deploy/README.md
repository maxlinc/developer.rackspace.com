## Production Setup

1. Download and install [Ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine).
   * On Mac OSX machines with [Homebrew](http://brew.sh/) installed, you can simply run: `$ brew install ansible`


2. Install pyrax.

   ```bash
   $ sudo pip install pyrax
   ```

3. Create a file named `~/.rackspace_cloud_credentials` with the following contents:

    ```
    [rackspace_cloud]
    username = <REPLACE WITH YOUR RACKSPACE CLOUD USERNAME>
    api_key = <REPLACE WITH YOUR RACKSPACE CLOUD API KEY>
    ```

4. Change to this directory on your development machine.

    ```bash
    $ cd /path/to/developer.rackspace.com/deploy
    ```

5. Run the Ansible playbook. This will take several minutes.

    ```bash
    $ ansible-playbook site.yml -i inventory/hosts.prod
    ```

6. In your Rackspace cloud control panel you should see the following:
   * 2 cloud servers in IAD named `webserver_iad_1` and `webserver_iad_2`.
   * 2 cloud servers in DFW named `webserver_dfw_1` and `webserver_dfw_2`.
   * 1 cloud load balancer in DFW named `weblb` with the 4 cloud servers from above as its nodes. Note the public IP address of this load balancer.

7. Each cloud server has nginx installed, configured and running.

8. Each cloud server has a `publisher` user, which can be used to upload static content to the site. The SSH public key for this user is already added to the user's `authorized_keys` file. The SSH private key is... well, private (ask @ycombinator for it). Static content should be uploaded over SSH (via scp/sftp/rsync) to `/var/www/html/developer.rackspace.com`.

9. The web site can be accessed via the public IP address of the cloud load balancer, as noted in step 6, over HTTP on port 80.

## Development Setup

1. Download and install [Vagrant](http://www.vagrantup.com/downloads.html).

2. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

3. Download and install [Ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine).
   * On Mac OSX machines with [Homebrew](http://brew.sh/) installed, you can simply run: `$ brew install ansible`

4. Change to this folder on your development machine.

    ```bash
    $ cd /path/to/developer.rackspace.com/deploy
    ```

5. Run Vagrant to set up a VirtualBox VM running a development environment.

    ```bash
    $ vagrant up
    ```

6. That's it! Your development environment is setup in a VirtualBox VM! It's contents are:
   * A web server running Nginx, accessible at [http://localhost:8000](http://localhost:8000).
      * Document root is `/var/www/html/developer.rackspace.com` on the VirtualBox VM.
   * An elasticsearch service, accessible via a REST API at [http://localhost:9200](http://localhost:9200).


## Folder Layout

* **Vagrantfile**: Vagrant file used to setup a development environment VM.
* **hosts.dev**: Ansible inventory file specifying development environment machines.
* **hosts.staging**: Ansible inventory file specifying staging environment machines.
* **hosts.prod**: Ansible inventory file specifying production environment machines.
* **site.yml**: Master Ansible playbook.
* **elasticsearch.yml**: Ansible playbook to setup Elasticsearch service tier.
* **web.yml**: Ansible playbook to setup Nginx web tier.
* **roles/**:
   * **bennojoy.nginx/**: See https://galaxy.ansible.com/list#/roles/2
