// lib/supabase.ts


import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://hpxkgyajpzxhnzrcmreu.supabase.co'
const supabaseKey = process.env.SUPABASE_KEY
const supabaseAnonKey= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhweGtneWFqcHp4aG56cmNtcmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1OTQxNjQsImV4cCI6MjA3MDE3MDE2NH0.nNz2Oq62Le-L-PDSWn44mUugD2O_MGhcCmOSVB5bDcw'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)