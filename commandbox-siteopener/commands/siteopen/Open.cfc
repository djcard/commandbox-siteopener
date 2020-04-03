/**
 * Presents a list of the sites installed, changes folders to that site and then starts / opens the CommandBox on your local computer.
 */
component {

    property name="serverService" inject="ServerService";
    servers = {};
    /**
     * Entry point to the command
     *@site The name of the site to open
     * @site.optionsUDF siteList
     */
    void function run(string site = '') {
        servers = serverService.getServers();
        site = site eq '' ? chooseSite() : site;
        var serverInfo = findServer(site);
        var specServer = serverInfo[serverInfo.keylist()];
        command('cd #specServer.webroot#').run();
        var action = serverService.isServerRunning(specServer) ? 'open' : 'start openbrowser=true';
        command('server #action#').run();
    }

    /**
     * Presents the site in the system as a multiselect
     */
    string function chooseSite() {
        var options = [];
        serverService
            .getServers()
            .map(function(serv) {
                options.append({display: servers[serv].name & '( ' & servers[serv.status] & ')', value: servers[serv].name});
            });
        return multiselect()
            .setQuestion('Which Site')
            .setoptions(options)
            .SetMultiple(false)
            .setRequired(true)
            .ask();
        print.line(servers);
    }

    /**
     *Returns the sites in the sytem as an array of string for property hinting
     */
    array function siteList() {
        var options = [];
        servers = serverService.getServers();
        servers.map(function(serv) {
            options.append(servers[serv].name);
        });
        return options;
    }

    /**
     * Accepts the name of a server and returns the key from servers that matches it
     *@serverName The name of the server to match
     */
    struct function findServer(required string serverName) {
        return servers.filter(function(item) {
            return servers[item].name eq serverName;
        });
    }

}
