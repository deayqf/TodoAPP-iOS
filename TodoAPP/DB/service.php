<?php
include( '../secure/_.php' );
$action = isset( $_POST[ 'action' ] ) ? $_POST[ 'action' ] : NULL;
if( !empty( $action ) )
{
	switch( $action )
	{
		case 'login':
			echo loginAttempt();
			break;
		case 'tasks':
			echo loadTasks();
			break;
		case 'insert_task':
			echo addTask();
			break;
		case 'update_notes':
			echo updateNotes();
			break;
		case 'delete_task':
			echo deleteTask();
			break;
		case 'update_task':
			echo updateTask();
			break;
		case 'register':
			echo register();
			break;
		case 'update_status':
			echo updateStatus();
			break;
        case 'update_title':
            echo updateTitle();
            break;
        case 'update_class':
            echo updateClass();
            break;
        case 'update_date':
            echo updateDate();
            break;
	}
}
else
{
	echo "Invalid action";
}

function loginAttempt()
{
	$usrnm = $_POST[ 'u' ];
	$psswd = $_POST[ 'p' ];

	$status_obj = array();
	$msg_obj = array();
	$msg_obj[ "status" ] = 0;

	$con = getConnection();
	if( $con === 1 )
	{
		$msg_obj[ "status" ] = 1;
	}

	$SQL = "SELECT * FROM users WHERE usrnm='{$usrnm}'";
	if( $result = mysqli_query( $con, $SQL ) )
	{
		if( $row = $result->fetch_object() )
		{
			if( !password_verify( $psswd, $row->phash ) )
			{
				$msg_obj[ "status" ] = 1;
			}
		}
		else
		{
			$msg_obj[ "status" ] = 1;
		}
	}
	else
	{
		$msg_obj[ "status" ] = 1;
	}
	mysqli_close( $con );
	array_push( $status_obj, $msg_obj );
	return json_encode( $status_obj );
}

function loadTasks()
{
	$con = getConnection();

	$usrnm = $_POST[ 'usrnm' ];

	$sql = "SELECT * FROM tasks WHERE usrnm='{$usrnm}'";
	if( $result = mysqli_query( $con, $sql ) )
	{
	    $result_array = array();
	    $temp_array   = array();

	    while( $row = $result->fetch_object() )
	    {
	        $temp_array = $row;
	        array_push( $result_array, $temp_array );
	    }
	    mysqli_close( $con );
	    return json_encode( $result_array );
	}
	mysqli_close( $con );
}

function addTask()
{
	$con = getConnection();

	$usrnm = $_POST[ 'usrnm' ];
	$name  = $_POST[ 'name'  ];
	$group = $_POST[ 'group' ];
	$due   = $_POST[ 'due'   ];

	$SQL = "INSERT INTO tasks ( usrnm, name, class, due, notes, status )
			VALUES ( '$usrnm', '$name', '$group', '$due', 'Your notes go here', '0' )";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );
	return loadTasks();
}

function updateNotes()
{
	$con = getConnection();

	$usrnm = $_POST[ 'usrnm' ];
	$title = $_POST[ 'title' ];
	$notes = $_POST[ 'notes' ];

	$SQL = "UPDATE tasks
			SET notes='{$notes}'
			WHERE usrnm='{$usrnm}' AND name='{$title}'";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );
	return loadTasks();
}

function deleteTask()
{
	$con = getConnection();

	$usrnm = $_POST[ 'usrnm' ];
	$name  = $_POST[ 'name'  ];

	$SQL = "DELETE FROM tasks
			WHERE usrnm='{$usrnm}' AND name='{$name}'";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );
	return "blah";
}

function updateTask()
{
	$con = getConnection();

	$usrnm    = $_POST[ 'usrnm' ];
	$old_name = $_POST[ 'old_name' ];
	$new_name = $_POST[ 'new_name' ];
	$group    = $_POST[ 'group' ];
	$due      = $_POST[ 'due' ];

	$SQL = "UPDATE tasks
			SET name='{$new_name}', class='{$group}', due='{$due}'
			WHERE usrnm='{$usrnm}' AND name='{$old_name}'";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );
	return "blah";
}

function checkUser( $usrnm )
{
    $con = getConnection();
    $SQL = "SELECT * FROM users WHERE usrnm='{$usrnm}'";

    $exists = 0;
    if( $result = mysqli_query( $con, $SQL ) )
    {
        if( $row = $result->fetch_object() )
        {
            $exists = 1;
        }
    }
    mysqli_close( $con );
    return $exists;
}

function register()
{
	$usrnm = $_POST[ 'u' ];
	$psswd = $_POST[ 'p' ];
	$phash = password_hash( $psswd, PASSWORD_DEFAULT );

	$status_obj = array();
	$msg_obj = array();
	$msg_obj[ "status" ] = 0;

    if( checkUser( $usrnm ) == 1 )
    {
        $msg_obj[ "status" ] = 1;
        array_push( $status_obj, $msg_obj );
        return json_encode( $status_obj );
    }

	$con = getConnection();

	$SQL = "INSERT INTO users ( usrnm, phash )
			VALUES ( '{$usrnm}', '{$phash}' )";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );

    array_push( $status_obj, $msg_obj );
	return json_encode( $status_obj );
}

function updateStatus()
{
	$usrnm  = $_POST[ 'usrnm'  ];
	$name   = $_POST[ 'name'   ];
	$status = $_POST[ 'status' ];

	$con = getConnection();

	$SQL = "UPDATE tasks
			SET status='{$status}'
			WHERE usrnm='{$usrnm}' AND name='{$name}'";

	$status = mysqli_query( $con, $SQL );
	mysqli_close( $con );
	return $status; 
}

function updateTitle()
{
    $usrnm = $_POST[ 'usrnm' ];
    $old   = $_POST[ 'old'   ];
    $new   = $_POST[ 'new'   ];

    $con = getConnection();

    $SQL = "UPDATE tasks
            SET name='{$new}'
            WHERE usrnm='{$usrnm}' AND name='{$old}'";

    $status = mysqli_query( $con, $SQL );
    mysqli_close( $con );
    return $status;
}

function updateClass()
{
    $usrnm = $_POST[ 'usrnm' ];
    $title = $_POST[ 'title' ];
    $class = $_POST[ 'class' ];

    $con = getConnection();

    $SQL = "UPDATE tasks
            SET class='{$class}'
            WHERE usrnm='{$usrnm}' AND name='{$title}'";

    $status = mysqli_query( $con, $SQL );
    mysqli_close( $con );
    return $status;
}

function updateDate()
{
    $usrnm = $_POST[ 'usrnm' ];
    $title = $_POST[ 'title' ];
    $date  = $_POST[ 'date'  ];

    $con = getConnection();

    $SQL = "UPDATE tasks
            SET due='{$date}'
            WHERE usrnm='{$usrnm}' AND name='{$title}'";

    $status = mysqli_query( $con, $SQL );
    mysqli_close( $con );
    return $status;
}
?>
