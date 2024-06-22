{{ config(materialized='table') }}


{% set colonnes_a_aggreger_list = lister_colonnes_a_aggreger() %}


with communes as (
    SELECT DISTINCT code_commune_insee from {{ ref('libelle_colonnes_logement') }}
  ),
  aggregated as (

    SELECT * 

    FROM communes

    {% for colonne_a_aggreger in colonnes_a_aggreger_list %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(colonnes_a_aggreger_list, colonne_a_aggreger) }} )
      USING (code_commune_insee)

    {% endfor %}

  )

SELECT 
    *  
FROM
    aggregated