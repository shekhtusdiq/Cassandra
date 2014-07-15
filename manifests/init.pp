#/etc/puppet/modules/cassandra/manifests/init.pp
class cassandra {
	
require cassandra::params	

	# Add path in global variable.
	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
	
	# To test param variables in /tmp/test.txt file.
	file { "/tmp/test.txt":
		ensure => 'file',
		alias => 'Test',
    		content => template("cassandra/test.txt.erb"),
	}
	
	#  
	package { "wget":
    		ensure => "installed",
		before => File['Test'],
	}

	# Create Installation directory
	file { "${cassandra::params::install_dir}":
    		ensure => "directory",
        	alias => "Base_dir",
		before => Exec["Download_tar"],
	}

	# Donwload tar file
	exec { "wget $get_url}":
		cwd => "/opt/cassandra/",
		command => "wget ${cassandra::params::get_url}",
		creates => "/opt/cassandra/apache-cassandra-2.0.9-bin.tar.gz",
		alias => "Download_tar",
	}
	
	# Extract Cassandra
	exec { "tar zxvf apache-cassandra-2.0.9-bin.tar.gz -C /opt/cassandra":
    		cwd => "/opt/cassandra/",
        	creates => "/opt/cassandra/apache-cassandra-2.0.9",
		alias => "extract",
		require => Exec['Download_tar']
	}
	
	# Startup script
	file { "/etc/init.d/cassandra":
		mode => 755,
		alias => "Init Script",
		content => template("cassandra/cassandra.erb"),
	}	

	# Copy cassandra.yaml
	file { "${cassandra::params::cassandra_home}/conf/cassandra.yaml":
             	ensure => 'file',
             	content => template("cassandra/cassandra.yaml.erb"),
	   	require => Exec['extract']
	}

	# Copy cassandraenv.sh
	file { "${cassandra::params::cassandra_home}/conf/cassandra-env.sh":
                ensure => 'file',
                content => template("cassandra/cassandra-env.sh.erb"),
                require => Exec['extract']
 	}
############################ Java Installation ###################################################

	# Copy JRE
	file { "${cassandra::params::cassandra_home}/jre-7u55-linux-x64.rpm":
    		ensure => 'file',
    		source => 'puppet:///modules/cassandra/jre-7u55-linux-x64.rpm', 
    	#	creates => '/opt/cassandra/apache-cassandra-2.0.9/jre-7u55-linux-x64.rpm',
    		alias => 'Copy_JRE',
		require => Exec['extract'],
	}	

	# rpm should be installed	
	package { 'rpm':
    		ensure => installed,
	}

	# Install JRE
	exec { "rpm -ivh jre-7u55-linux-x64.rpm":
     		cwd => "${cassandra::params::cassandra_home}",
		creates => '/usr/java/jre1.7.0_55/',
		require => File['Copy_JRE']
	}

	# Set Java Env
	file { "/etc/profile.d/setenv.sh":
    		ensure => 'file',
    		content => template("cassandra/setenv.sh.erb"),
		alias => 'Copy_ENV'
	}

	exec { "Set Env Path":
    		command => "bash -c 'source /etc/profile'",
		require => File['Copy_ENV'],
	}
 		
}
