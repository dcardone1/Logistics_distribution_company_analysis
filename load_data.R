library(DBI)
library(duckdb)
library(fs)
library(stringr)

# 1. Definir la carpeta ficticia donde están los CSV
directorio_csv <- "data"

# 2. Listar los archivos CSV
lista_archivos <- dir_ls(path = directorio_csv, glob = "*.csv")

# 3. Crear la conexión a DuckDB en memoria
con <- dbConnect(duckdb(), dbdir = ":memory:")
print('Conexión creada: con')

# 4. Iterar sobre cada archivo para crear una tabla individual
for (archivo in lista_archivos) {
    
    nombre_tabla <- path_ext_remove(path_file(archivo))
    
    # Limpiar el nombre por seguridad (reemplazar caracteres no alfanuméricos por _)
    nombre_tabla <- str_replace_all(nombre_tabla, "[^a-zA-Z0-9_]", "_")
    
    # Crear la tabla dinámicamente en DuckDB
    query <- sprintf(
        "CREATE TABLE %s AS SELECT * FROM read_csv_auto('%s')",
        nombre_tabla,
        archivo
    )
    
    dbExecute(con, query)
    
}

# 5. Verificar qué tablas se crearon en la base de datos
tablas_creadas <- dbListTables(con)
print('Tablas creadas:')
print(tablas_creadas)




