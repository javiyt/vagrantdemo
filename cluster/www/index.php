<?php
// Code example from http://www.php.net/manual/en/function.mysql-fetch-array.php, don't use it in production

$link = mysql_connect('192.168.50.2', 'vagrant', 'vagrant') or die('No se pudo conectar: ' . mysql_error());

echo 'Connected successfully';

mysql_select_db('test') or die('No se pudo seleccionar la base de datos');

// Realizar una consulta MySQL
$query = 'SELECT * FROM City';
$result = mysql_query($query) or die('Consulta fallida: ' . mysql_error());

// Imprimir los resultados en HTML
echo "<table>\n";
while ($line = mysql_fetch_array($result, MYSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Liberar resultados
mysql_free_result($result);

// Cerrar la conexión
mysql_close($link);
