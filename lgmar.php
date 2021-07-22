<?php
if($_SERVER["REQUEST_METHOD"] == "POST"){

	$input_text = $_REQUEST['input_text'];
	//$input_text = "DAS";
	if( !empty($input_text)){
		
		
		$db	=  new PDO('mysql:host=localhost;dbname=lgmartest', 'root', '');

		$sql = "INSERT INTO lgmar_add_input_string(
				input_string, 	time_now	)
				VALUES(
				:input_string, :time_now
				)";


		try {
			$stmt = $db->prepare($sql);
			$stmt->bindValue(':input_string'  , $input_text	    , PDO::PARAM_STR);
			$stmt->bindValue(':time_now'	  ,  date("Y/m/d")  , PDO::PARAM_STR);
			$stmt->execute();
			}catch(PDOException $ex) {error_log("failed at inserting string to lgmar_add_input_string". $ex->getMessage());}	

			$data = array(	
							'status' => 'success',
							'data'	 => strlen($input_text),
							'msg'	 => 'GOOD JOB WITH THE INPUT'
						 );
			
	}
	else{
		$data = array(	
					'status' => 'failed',
					'data'	 => -1,
					'msg'	 => 'No text received'
				 );

	}

	die(json_encode(array("data" => $data)));
}   


?>





    