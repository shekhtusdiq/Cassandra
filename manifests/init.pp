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

       # Add Group cassandra
	group { "cassandra":
    		ensure => "present",
    		gid => '1001',
		#before => 'Download_tar',
	}
	
	# Add User cassandra
	user { 'cassandra':
  		ensure           => 'present',
  		gid              => '1001',
  		groups           => 'cassandra',
  		home             => "${cassandra::params::install_dir}",
  		password         => '$6$5qu6iW.hdIp$N4TF2DYDkVd0S72OBNeUbEMuv8OOxBuUvsOtfDpc3Pe2/0fqdv.7R5lss7anNoNHYXwd49lK.Y3X5iUUEIN57/',
  		password_max_age => '99999',
  		password_min_age => '0',
  		shell            => '/bin/bash',
  		uid              => '1001',
  		managehome       => true,
  		require          => Group["cassandra"],
	}		
	
	# Download Package
	exec { "wget $get_url}":
		user => 'cassandra',
		cwd => "${cassandra::params::install_dir}",
		command => "wget ${cassandra::params::get_url}",
		timeout => 1800,
		tries   => 2,
		creates => "/home/cassandra/apache-cassandra-2.0.9-bin.tar.gz",
		alias => 'Download_tar',
		require => User["cassandra"],
	}
	# Extract cassandra
	exec { "tar zxvf apache-cassandra-2.0.10-bin.tar.gz -C /home/cassandra":
    		user => 'cassandra',
		cwd => "${cassandra::params::install_dir}",
        	creates => "${cassandra::params::cassandra_home}",
		alias => "extract",
		require => Exec['Download_tar']
	}
	# Copy JRE
        file { "${cassandra::params::cassandra_home}/jre-7u55-linux-x64.gz":
                owner => 'cassandra',
		group => 'cassandra',
		ensure => 'file',
                source => 'puppet:///modules/cassandra/jre-7u55-linux-x64.gz',
                alias => 'Copy_JRE',
                require => Exec["extract"],
        }
	# Extract JRE
	exec { "tar zxvf jre-7u55-linux-x64.gz":
		user => 'cassandra',
		cwd => "${cassandra::params::cassandra_home}",
                creates => "${cassandra::params::jre_home}",
                alias => "Extract_JRE",
                require => File['Copy_JRE']
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
	# Set Java Env
        file { "/etc/profile.d/setenv.sh":
                ensure => 'file',
                content => template("cassandra/setenv.sh.erb"),
                alias => 'Copy_ENV'
        }
	# Startup script
        file { "/etc/init.d/cassandra":
                mode => 755,
                alias => "Init Script",
                content => template("cassandra/cassandra.erb"),
        }

}
