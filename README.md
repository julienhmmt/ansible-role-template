# ansible-role-template

> A simple and opinionated ansible role template.

## Requirements

- Ansible >= 2.15
- Python >= 3.10 (control node)
- Supported OS : Debian 13 (trixie), Ubuntu 24.04 (noble)

## Role Variables

### Defaults (`defaults/main.yml`)

Variables intended to be overridden by the user.

| Variable | Default | Description |
| -------- | ------- | ----------- |
| `ansible_role_template_manage_service` | `true` | Enables systemd service management |
| `ansible_role_template_service_name` | `"example"` | Name of the systemd service to manage |

## Dependencies

No external dependencies. If Galaxy roles are required, list them in `meta/main.yml` **and** in a `requirements.yml` file at the root of the playbook.

## Available Tags

| Tag | Effect |
| --- | ----- |
| `install` | Only package installation tasks |
| `configure` | Only configuration tasks |
| `service` | Only systemd service management |

## Example Playbook

```yaml
- hosts: servers
  become: true
  roles:
    - role: ansible-role-template
      vars:
        ansible_role_template_manage_service: true
```

## Testing

### Prerequisites

```bash
pip install -r requirements-dev.txt
```

Docker must be available on the development machine.

### Commands

```bash
make test          # full cycle
make converge      # deploys in the container
make verify        # runs assertions
make login         # shell in the container for debugging
make idempotence   # verifies that a second run changes nothing
molecule test -s no_service   # lightweight scenario without systemd
make lint          # yamllint + ansible-lint
```

### Molecule Scenarios

| Scenario | Image | Systemd | Usage |
| -------- | ----- | ------- | ----- |
| `default` | Debian 13 (custom build) | yes | Full test with services |
| `no_service` | `debian:trixie-slim` | no | Quick install/configure test |

### Notes on systemd in Docker

The `default` scenario uses a privileged-free container with `cgroupns_mode: host`, `/sys/fs/cgroup` mounted in `rw`, tmpfs on `/run` and `/tmp`, `CAP_SYS_ADMIN` and `command: /sbin/init`.

## CI

The GitHub Actions pipeline (`.github/workflows/ansible.yml`) executes: lint (yamllint + ansible-lint) then molecule test on each scenario.

## License

AGPL 3.0

## Author

Julien HOMMET
