

import netifaces
import yaml


def load_interfaces(db):
    interfaces = {}

    for intf in netifaces.interfaces():
        addrs = {}
        interfaces[intf] = {
            'addresses': netifaces.ifaddresses(intf)
        }


    return {'interfaces': interfaces}

def save_data(db, file_name):
    with open(file_name, 'w') as file:
        yaml.dump(db, file)
        print('saved to %s' % file_name)


def cli():
    db = {}

    db.update(load_interfaces(db))
    save_data(db, 'network.yaml')

if __name__ == '__main__':
    cli()


#
