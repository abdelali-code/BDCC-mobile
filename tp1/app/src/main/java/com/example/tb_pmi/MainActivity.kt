package com.example.tb_pmi
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    private lateinit var editTextPoids: EditText
    private lateinit var editTextTaille: EditText
    private lateinit var btnCalculer: Button
    private lateinit var textViewResultat: TextView
    private lateinit var imageViewCategorie: ImageView
    private lateinit var textViewCategorie: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Récupération des vues (comme dans "First App")
        editTextPoids = findViewById(R.id.editTextPoids)
        editTextTaille = findViewById(R.id.editTextTaille)
        btnCalculer = findViewById(R.id.btnCalculer)
        textViewResultat = findViewById(R.id.textViewResultat)
        imageViewCategorie = findViewById(R.id.imageViewCategorie)
        textViewCategorie = findViewById(R.id.textViewCategorie)

        btnCalculer.setOnClickListener {
            calculerIMC()
        }
    }

    private fun calculerIMC() {
        val poidsStr = editTextPoids.text.toString()
        val tailleStr = editTextTaille.text.toString()

        if (poidsStr.isEmpty() || tailleStr.isEmpty()) {
            textViewResultat.text = "Veuillez saisir le poids et la taille"
            return
        }

        val poids = poidsStr.toDouble()          // en Kg
        val tailleCm = tailleStr.toDouble()       // en Cm
        val tailleM = tailleCm / 100.0            // conversion en mètres

        val imc = poids / (tailleM * tailleM)
        val imcArrondi = Math.round(imc * 100.0) / 100.0

        textViewResultat.text = "${getString(R.string.str_votre_imc_est)} $imcArrondi"

        afficherCategorie(imc)
    }

    private fun afficherCategorie(imc: Double) {
        when {
            imc < 18.5 -> {
                textViewCategorie.text = getString(R.string.cat_maigreur)
                textViewCategorie.setTextColor(getColor(R.color.colorMaigreur))
                imageViewCategorie.setImageResource(R.drawable.ic_maigreur)
            }
            imc in 18.5..24.99 -> {
                textViewCategorie.text = getString(R.string.cat_normal)
                textViewCategorie.setTextColor(getColor(R.color.colorNormal))
                imageViewCategorie.setImageResource(R.drawable.ic_normal)
            }
            imc in 25.0..29.99 -> {
                textViewCategorie.text = getString(R.string.cat_surpoids)
                textViewCategorie.setTextColor(getColor(R.color.colorSurpoids))
                imageViewCategorie.setImageResource(R.drawable.ic_surpoids)
            }
            imc in 30.0..39.99 -> {
                textViewCategorie.text = getString(R.string.cat_obesite_moderee)
                textViewCategorie.setTextColor(getColor(R.color.colorObesiteModeree))
                imageViewCategorie.setImageResource(R.drawable.ic_obesite_moderee)
            }
            else -> {
                textViewCategorie.text = getString(R.string.cat_obesite_severe)
                textViewCategorie.setTextColor(getColor(R.color.colorObesiteSevere))
                imageViewCategorie.setImageResource(R.drawable.ic_obesite_severe)
            }
        }
    }
}